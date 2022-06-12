// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../../address/adapters/TruhuisAddressRegistryAdapter.sol";

contract TruhuisMarketplace is
    Ownable,
    TruhuisAddressRegistryAdapter,
    ReentrancyGuard,
    KeeperCompatibleInterface
{
    /// @notice Reverted if a Real Estate purchase is failed.
    error TruhuisMarketplace__RealEstatePurchaseFailed();
    /// @notice Reverted if an auction for a provided token ID didn't finish yet.
    error TruhuisMarketplace__AuctionIsInAction(uint256 tokenId);
    /// @notice Reverted if a price is less than zero or equal to zero.
    error TruhuisMarketplace__PriceMustBeGreaterThanZero(uint256 price);
    /// @notice Reverted if a buyer has insufficient funds to purhcase a property.
    error TruhuisMarketplace__InsufficientFunds(uint256 salePrice, uint256 avaliableFunds);

    /// @notice Reverted if an ERC-20 currency is unsupported by the marketplace.
    error TruhuisMarketplace__InvalidCurrency(address invalidCurrency);
    /// @notice Reverted if a provided offer is invalid for a particular token ID.
    error TruhuisMarketplace__InvalidOfferer(address offerer, address invalidOffererd);

    /// @notice Reverted if a provided offer already exists.
    error TruhuisMarketplace__OfferAlreadyExists(address offerer, uint256 tokenId);
    /// @notice Reverted if a provided offer is non-existent.
    error TruhuisMarketplace__OfferNotExists(address offerer, uint256 tokenId);
    /// @notice Reverted if a provided offer is expired.
    error TruhuisMarketplace__OfferIsExpired(address offerer, uint256 tokenId);

    /// @notice Reverted if a provided listing is non-existent.
    error TruhuisMarketplace__ListingNotExists(uint256 tokenId);
    /// @notice Reverted if a provided listing alrady exists.
    error TruhuisMarketplace__ListingAlreadyExists(uint256 tokenId);

    /// @notice Reverted if a marketplace owner update fails.
    error TruhuisMarketplace__MarketplaceOwnerUpdateFailed();
    /// @notice Reverted if a marketplace commission fraction update fails.
    error TruhuisMarketplace__MarketplaceCommissionFractionUpdateFailed();
    error TruhuisMarketplace__BuyerIsNotAllowedToPurchaseRealEstate(address _buyer, uint256 _tokenId);
    error TruhuisMarketplace__AccountIsPropertyOwner(address account, uint256 tokenId);
    error TruhuisMarketplace__AccountIsNotPropertyOwner(address account, uint256 tokenId);
    error TruhuisMarketplace__AccountIsNotHuman(address account);
    error TruhuisMarketplace__SellerIsNotAllowedToPurchaseRealEstate(address seller, uint256 tokenId);

    enum Stage {
        available,
        negotiation,
        coolingOffPeriod,
        sold
    }

    struct Listing {
        bool exists;
        Stage status;
        address currency;
        uint256 initialPrice;
        uint256 purchasePrice;
        uint256 purchaseTime;
        uint256 initialTime;
        uint256 tokenId;
        uint256 coolingOffPeriod;
        address buyer;
        address seller;
    }

    struct Offer {
        address offerer;
        address currency;
        bool exists;
        uint256 price;
        uint256 expiry;
    }

    /// @dev Marketplace owner and Truhuis Marketplace service fee receiver.
    address public marketplaceOwner;
    /// @dev Truhuis Marketplace service fee (e.g. 100 (1%); 1000 (10%)).
    uint96 public marketplaceCommissionFraction;

    /// @dev Token ID => buyer => is or isn't verified.
    mapping(uint256 => mapping(address => bool)) public s_isVerifiedBuyer;
    /// @dev Token ID => seller => is or isn't verified.
    mapping(uint256 => mapping(address => bool)) public s_isVerifiedSeller;

    /// @dev Token ID => Listing struct
    mapping(uint256 => Listing) public s_listings;  
    /// @dev Token ID => offerer => Offer struct
    mapping(uint256 => mapping(address => Offer)) public s_offers; 

    /// @dev seller => supported currency => allowed seller proceeds to withdraw
    mapping(address => mapping(address => uint256)) public s_sellerProceeds;
    /// @dev Transfer Tax Receiver => supported currency => allowed transfer taxes to withdraw
    mapping(address => mapping(address => uint256)) public s_transferTaxes;
    /// @dev Supported currency => allowed marketplace proceeds to withdraw
    mapping(address => uint256) public s_marketplaceProceeds;

    event RealEstateListed(
        address indexed seller,
        uint256 indexed tokenId,
        bytes3 indexed propertyCountry,
        address currency,
        uint256 initialTime,
        uint256 initialPrice,
        uint256 coolingOffPeriod,
        Stage stage
    );

    event RealEstatePurchased(
        address indexed buyer,
        address indexed seller,
        uint256 indexed tokenId,
        uint256 purchaseTime,
        uint256 purchasePrice,
        Stage stage
    );

    event RealEstateSold(
        address indexed buyer,
        address indexed seller,
        uint256 indexed tokenId,
        uint256 soldTime,
        uint256 soldPrice,
        Stage stage
    );

    event ListingCanceled(
        address indexed seller,
        uint256 indexed tokenId
    );

    event OfferCreated(
        address indexed offerer,
        uint256 indexed tokenId,
        address currency,
        uint256 price,
        uint256 expiry
    );

    event OfferAccepted(
        address indexed seller,
        uint256 indexed tokenId,
        address indexed buyer,
        uint256 purchaseTime,
        uint256 purchasePrice,
        Stage stage
    );

    event OfferCanceled(
        address indexed offerer,
        uint256 indexed tokenId
    );

    event PurchaseCanceled(
        address indexed buyer,
        uint256 indexed tokenId,
        Stage stage
    );

    event MarketplaceOwnerUpdated(
        address newOwner
    );

    event MarketplaceCommissionFractionUpdated(
        uint256 newCommissionFraction
    );

    event SellerProceedsWithdrew(
        address indexed seller,
        address indexed currency,
        uint256 indexed sellerProceeds
    );

    event TransferTaxesWithdrew(
        address indexed transferTaxReceiver,
        address indexed currency,
        uint256 indexed transferTaxes
    );

    event MarketplaceProceedsWithdrew(
        address indexed currency,
        uint256 indexed marketplaceProceeds
    );

    modifier onlyBuyer(address _buyer, uint256 _tokenId) {
        if (!s_isVerifiedBuyer[_tokenId][_buyer]) {
            verifyBuyer(_buyer, _tokenId);
        }
        _;
    }

    modifier onlySeller(address _seller, uint256 _tokenId) {
        if (!s_isVerifiedSeller[_tokenId][_seller]) {
            verifySeller(_seller, _tokenId);
        }
        _;
    }

    constructor(address _addressRegistry) {
        marketplaceOwner = msg.sender;
        marketplaceCommissionFraction = 250; 
        updateAddressRegistry(_addressRegistry);
    }

    //      *            *                 *                 *
    //          LISTING        LISTING           LISTING
    //      *            *                 *                 *
    
    function listRealEstate(address _currency, uint256 _tokenId, uint256 _price)
        external
        onlySeller(msg.sender, _tokenId)
    {
        // Validate contract logic.
        _validateIsNonExistentListing(_tokenId);

        // Validate function arguments.
        _validateIsAllowedCurrency(_currency);
        _validateIsPriceGreaterThanZero(_price);

        // List Real Estate for sale.
        Listing storage s_listing = s_listings[_tokenId];

        s_listing.exists = true;
        s_listing.status = Stage.available;
        s_listing.currency = _currency;
        s_listing.initialPrice = _price;
        s_listing.initialTime = _getNow();
        s_listing.seller = msg.sender;
        s_listing.tokenId = _tokenId;
        s_listing.coolingOffPeriod = getCoolingOffPeriod(_tokenId);
        s_listing.buyer = address(0);
        s_listing.purchaseTime = 0;
        s_listing.purchasePrice = 0;

        // Get Real Estate country of location.
        bytes3 propertyCountry = getRealEstateCountry(_tokenId);

        // Emit Real Estate Listed event.
        emit RealEstateListed(
            msg.sender,
            _tokenId,
            propertyCountry,
            _currency,
            s_listing.initialTime,
            _price,
            s_listing.coolingOffPeriod,
            Stage.available
        );
    }

    function purchaseRealEstate(uint256 _tokenId)
        external
        nonReentrant
        onlyBuyer(msg.sender, _tokenId)
    {
        // Validate contract logic.
        _validateIsExistentListing(_tokenId);

        Listing storage s_listing = s_listings[_tokenId];
        
        // Validate buyer has sufficient funds to purchase the property.
        _validateHasSufficientFunds(msg.sender, s_listing.currency, s_listing.initialPrice);

        // Purchase Real Estate.
        s_listing.buyer = msg.sender;
        s_listing.purchasePrice = s_listing.initialPrice;
        s_listing.purchaseTime = block.timestamp;

        _purchaseRealEstate(msg.sender, _tokenId, s_listing.initialPrice);

        // Emit Real Estate Purchased event.
        emit RealEstatePurchased(
            msg.sender,
            s_listing.seller,
            _tokenId,
            s_listing.purchaseTime,
            s_listing.purchasePrice,
            s_listing.status
        );
    }

    function updateListing(address _currency, uint256 _tokenId, uint256 _newPrice)
        external
        onlySeller(msg.sender, _tokenId)
    {
        // Validate contract logic.
        _validateIsExistentListing(_tokenId);

        // Validate function arguments.
        _validateIsAllowedCurrency(_currency);
        _validateIsPriceGreaterThanZero(_newPrice);

        // Update listing.
        Listing storage s_listing = s_listings[_tokenId];
        
        s_listing.currency = _currency;
        s_listing.initialPrice = _newPrice;

        // Get Real Estate country of location.
        bytes3 propertyCountry = getRealEstateCountry(_tokenId);

        // Emit Real Estate Listed event.
        emit RealEstateListed(
            msg.sender,
            _tokenId,
            propertyCountry,
            _currency,
            s_listing.initialTime,
            _newPrice,
            s_listing.coolingOffPeriod,
            Stage.available
        );
    }

    function cancelListing(uint256 _tokenId)
        external
        onlySeller(msg.sender, _tokenId)
    {
        _validateIsExistentListing(_tokenId);

        delete s_listings[_tokenId];
        //delete s_offers[_tokenId];
        delete s_isVerifiedSeller[_tokenId][msg.sender];

        emit ListingCanceled(
            msg.sender,
            _tokenId
        );
    }

    //      *           *               *               *
    //          OFFER         OFFER           OFFER
    //      *           *               *               *

    function createOffer(
        address _currency,
        uint256 _tokenId,
        uint256 _price,
        uint256 _expiry
    )
        external
        onlyBuyer(msg.sender, _tokenId)
    {
        // Validate contract logic.
        _validateIsNotAuctionInAction(_tokenId);
        _validateIsNonExistentOffer(msg.sender, _tokenId);
        _validateIsExistentListing(_tokenId);

        // Validate function arguments.
        _validateIsListingCurrency(_currency, _tokenId);
        _validateIsAllowedCurrency(_currency);
        _validateIsPriceGreaterThanZero(_price);

        // Validate offerer has sufficient funds to purchase the property.
        _validateHasSufficientFunds(msg.sender, _currency, _tokenId);

        // Create offer.
        s_offers[_tokenId][msg.sender] = Offer({
            offerer: msg.sender,
            currency: _currency,
            exists: true,
            price: _price,
            expiry: _expiry
        });

        // Emit Offer Created event.
        emit OfferCreated(
            msg.sender,
            _tokenId,
            _currency,
            _price,
            _expiry
        );
    }

    function acceptOffer(uint256 _tokenId, address _offerer)
        external
        nonReentrant
        onlySeller(msg.sender, _tokenId)
    {
        // Validate contract logic.
        _validateIsNotAuctionInAction(_tokenId);
        _validateIsExistentOffer(_offerer, _tokenId);

        Offer memory offer = s_offers[_tokenId][_offerer];

        // Validate offerer still has sufficient funds to purchase the property.
        _validateHasSufficientFunds(_offerer, offer.currency, offer.price);

        // Accept offer.
        Listing storage s_listing = s_listings[_tokenId];

        s_listing.buyer = _offerer;
        s_listing.purchasePrice = offer.price;
        s_listing.purchaseTime = block.timestamp;

        // Purchase Real Estate.
        _purchaseRealEstate(_offerer, _tokenId, offer.price);

        // Emit Offer Accepted event.
        emit OfferAccepted(
            s_listing.seller,
            _tokenId,
            msg.sender,
            s_listing.purchaseTime,
            s_listing.purchasePrice,
            Stage.coolingOffPeriod
        );

        // Clean accepted offer.
        delete s_offers[_tokenId][_offerer];
    }

    function cancelOffer(uint256 _tokenId)
        external
        onlyBuyer(msg.sender, _tokenId)
    {
        // Validate contract logic.
        _validateIsExistentListing(_tokenId);
        _validateIsExistentOffer(msg.sender, _tokenId);

        Offer memory offer = s_offers[_tokenId][msg.sender];
        _validateIsOffererMsgSender(offer.offerer, msg.sender);

        delete s_offers[_tokenId][msg.sender];
        delete s_isVerifiedBuyer[_tokenId][msg.sender];

        emit OfferCanceled(
            msg.sender,
            _tokenId
        );
    }

    function cancelPurchase(uint256 _tokenId)
        external
        nonReentrant
        onlyBuyer(msg.sender, _tokenId)
    {
        _validateIsExistentListing(_tokenId);
        Listing storage s_listing = s_listings[_tokenId];

        require(s_listing.buyer == msg.sender, "invalid buyer");
        require(s_listing.status == Stage.coolingOffPeriod, "real estate wasn't purchased");
        require(s_listing.exists, "nonexistent listing");

        uint256 purchasePrice = s_listing.purchasePrice;

        delete s_listing.buyer;
        delete s_listing.purchasePrice;
        delete s_listing.purchaseTime;

        require(IERC20(s_listing.currency).transfer(msg.sender, purchasePrice), "purchase cancelation error");

        emit PurchaseCanceled(
            msg.sender,
            _tokenId,
            Stage.available
        );
    }

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // UPDATE ONLY OWNER
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    /// @notice Update marketplace owner address.
    /// @param _newOwner The new marketplace owner address.
    function updateMarketplaceOwner(address _newOwner) external onlyOwner {
        if (_newOwner == marketplaceOwner) {
            revert TruhuisMarketplace__MarketplaceOwnerUpdateFailed();
        }

        marketplaceOwner = _newOwner;
        emit MarketplaceOwnerUpdated(_newOwner);
    }

    /// @notice Update marketplace commission fraction.
    /// @param _newCommissionFraction The new marketplace commission fraction.
    function updateMarketplaceCommissionFraction(uint96 _newCommissionFraction)
        external
        onlyOwner
    {
        if (_newCommissionFraction == marketplaceCommissionFraction) {
            revert TruhuisMarketplace__MarketplaceCommissionFractionUpdateFailed();
        }

        marketplaceCommissionFraction = _newCommissionFraction;
        emit MarketplaceCommissionFractionUpdated(_newCommissionFraction);
    }

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // EXTERNAL
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    function withdrawTransferTaxes(address _currency) external nonReentrant {
        uint256 transferTaxes = s_transferTaxes[msg.sender][_currency];

        require(transferTaxes > 0, "no transfer taxes");

        s_transferTaxes[msg.sender][_currency] = 0;

        require(IERC20(_currency).transfer(msg.sender, transferTaxes), "failed to withdraw transfer taxes");

        emit TransferTaxesWithdrew(msg.sender, _currency, transferTaxes);
    }

    function withdrawSellerProceeds(address _currency) external nonReentrant {
        uint256 proceeds = s_sellerProceeds[msg.sender][_currency];
        
        require(proceeds > 0, "no proceeds");

        s_sellerProceeds[msg.sender][_currency] = 0;
        
        require(IERC20(_currency).transfer(msg.sender, proceeds), "failed to withdraw proceeds");

        emit SellerProceedsWithdrew(msg.sender, _currency, proceeds);
    }

    function withdrawMarketplaceProceeds(address _currency) external nonReentrant {
        require(msg.sender == marketplaceOwner, "not marketplace owner");

        uint256 marketplaceProceeds = s_marketplaceProceeds[_currency];

        require(marketplaceProceeds > 0, "no marketplace proceeds");

        s_marketplaceProceeds[_currency] = 0;

        require(
            IERC20(_currency).transfer(marketplaceOwner, marketplaceProceeds),
            "failed to withdraw marketplace proceeds"
        );

        emit MarketplaceProceedsWithdrew(_currency, marketplaceProceeds);
    }

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // PUBLIC
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    function verifySeller(address _seller, uint256 _tokenId) public {
        if (!s_isVerifiedSeller[_tokenId][_seller]) {
            _validateIsHuman(_seller);
            _validateIsPropertyOwner(_seller, _tokenId);
            _validateSeller(_seller, _tokenId);
            require(isMarketplaceApproved(_tokenId), "marketplace must be approved");
            //require(isAuctionApproved(_tokenId), "auction must be approved");
            s_isVerifiedSeller[_tokenId][_seller] = true;
        }
    }

    function verifyBuyer(address _buyer, uint256 _tokenId) public {
        if (!s_isVerifiedBuyer[_tokenId][_buyer]) {
            _validateIsHuman(_buyer);
            _validateIsNotPropertyOwner(_buyer, _tokenId);
            _validateBuyer(_buyer, _tokenId);
            require(isMarketplaceApproved(_tokenId), "marketplace must be approved");
            //require(isAuctionApproved(_tokenId), "auction must be approved");
            s_isVerifiedBuyer[_tokenId][_buyer] = true;
        }
    }

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // PUBLIC VIEW RETURNS
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    function getBuyer(uint256 _tokenId) public view returns (address) {
        _validateIsExistentListing(_tokenId);
        return s_listings[_tokenId].buyer;
    }

    function getCoolingOffPeriod(uint256 _tokenId) public view returns (uint256) {
        (address stateGov,) = cadastre().royaltyInfo(_tokenId, uint256(1));
        uint256 coolingOffPeriod = IStateGovernment(stateGov).getCoolingOffPeriod();
        return coolingOffPeriod;
    }

    function getInitialTime(uint256 _tokenId) public view returns (uint256) {
        _validateIsExistentListing(_tokenId);
        return s_listings[_tokenId].initialTime;
    }

    function getListing(uint256 _tokenId) public view returns (Listing memory) {
        _validateIsExistentListing(_tokenId);
        return s_listings[_tokenId];
    }

    function getMarketplaceCommission(uint256 _salePrice) public view returns (uint256) {
        // price = 250000 USDT * (10**18)
        // price * 250 / 10000 = 6250 USDT * (10**18)
        return _salePrice * marketplaceCommissionFraction / 10000;
    }

    function getRealEstateCountry(uint256 _tokenId) public view returns (bytes3) {
        (address transferTaxReceiver,) = cadastre().royaltyInfo(_tokenId, uint256(1));
        bytes3 country = stateGovernment(transferTaxReceiver).getStateGovernmentCountry();
        return country;
    }

    function getTransferTaxes(address _transferTaxReceiver, address _currency) external view returns (uint256) {
        return s_transferTaxes[_transferTaxReceiver][_currency];
    }

    function getSellerProceeds(address _seller, address _currency) external view returns (uint256) {
        return s_sellerProceeds[_seller][_currency];
    }

    function getMarketplaceProceeds(address _currency) public view returns (uint256) {
        return s_marketplaceProceeds[_currency];
    }

    function getTransferTaxInfo(address _buyer, uint256 _tokenId, uint256 _salePrice) public view returns (address, uint256) {
        _validateBuyer(_buyer, _tokenId);
        (address transferTaxReceiver, uint256 transferTax) = cadastre().royaltyInfo(_tokenId, _salePrice);
        require(transferTaxReceiver != address(0) && transferTax > 0, "invalid transfer tax information");
        return (transferTaxReceiver, transferTax);
    }

    function isAuctionInAction(uint256 _tokenId) public view returns (bool) {
        return auction().getStartTime(_tokenId) > 0;
    }

    function isHuman(address _account) public view returns (bool) {
        uint256 codeLength;
        assembly {codeLength := extcodesize(_account)}
        return codeLength == 0 && _account != address(0);
    }

    //function isAuctionApproved(uint256 _tokenId) public view returns (bool) {
    //    return (
    //        cadastre().isApprovedForAll(cadastre().ownerOf(_tokenId), address(auction()))
    //        || cadastre().getApproved(_tokenId) == address(auction())
    //    );
    //}

    function isListingExistent(uint256 _tokenId) public view returns (bool) {
        return s_listings[_tokenId].exists;
    }
    
    function isMarketplaceApproved(uint256 _tokenId) public view returns (bool) {
        return (
            cadastre().isApprovedForAll(cadastre().ownerOf(_tokenId), address(this))
            || cadastre().getApproved(_tokenId) == address(this)
        );
    }

    function isOfferExistent(address _offerer, uint256 _tokenId) public view returns (bool) {
        return s_offers[_tokenId][_offerer].exists;
    }

    //function isOfferExpired(address _offerer, uint256 _tokenId) public view returns (bool) {
    //    return s_offers[_tokenId][_offerer].expiry > _getNow();
    //}

    function isPropertyOwner(address _account, uint256 _tokenId) public view returns (bool) {
        return cadastre().isOwner(_account, _tokenId);
    }

    function isVerifiedBuyer(address _buyer, uint256 _tokenId) public view returns (bool) {
        return s_isVerifiedBuyer[_tokenId][_buyer];
    }

    function isVerifiedSeller(address _seller, uint256 _tokenId) public view returns (bool) {
        return s_isVerifiedSeller[_tokenId][_seller];
    }

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // INTERNAL & PRIVATE
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    function _getNow() internal view returns (uint256) {
        return block.timestamp;
    }

    function _purchaseRealEstate(address _buyer, uint256 _tokenId, uint256 _salePrice) internal {
        Listing storage s_listing = s_listings[_tokenId];

        s_listing.status = Stage.coolingOffPeriod;

        if (
            IERC20(s_listing.currency).transferFrom(
                _buyer,
                address(this),
                _salePrice
            ) == false) {
            revert TruhuisMarketplace__RealEstatePurchaseFailed();
        }
    }

    function _transferNftFrom(address _seller, address _buyer, uint256 _tokenId) internal {
        IERC721(cadastre()).transferFrom(_seller, _buyer, _tokenId);
    }

    function checkUpkeep(bytes calldata _checkData)
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        uint256 tokenId = abi.decode(_checkData, (uint256));
        Listing memory listing = s_listings[tokenId];

        upkeepNeeded = block.timestamp > (listing.purchaseTime + listing.coolingOffPeriod);

        return (
            upkeepNeeded,
            abi.encode(tokenId)
        );
    }

    function performUpkeep(bytes calldata _performData) external override {
        uint256 tokenId = abi.decode(_performData, (uint256));
        Listing memory listing = s_listings[tokenId];

        require(msg.sender != address(0), "invalid caller");
        _validateIsExistentListing(tokenId);
        require(listing.status == Stage.coolingOffPeriod, "invalid status");
        require(block.timestamp > (listing.purchaseTime + listing.coolingOffPeriod), "invalid time");

        s_listings[tokenId].status = Stage.sold;
        s_listings[tokenId].exists = false;

        uint256 marketplaceCommission = getMarketplaceCommission(listing.purchasePrice);
        s_marketplaceProceeds[listing.currency] += marketplaceCommission;

        (address transferTaxReceiver, uint256 transferTax) = getTransferTaxInfo(
            listing.buyer, tokenId, listing.purchasePrice - marketplaceCommission
        ); 
        s_transferTaxes[transferTaxReceiver][listing.currency] += transferTax; 

        _transferNftFrom(listing.seller, listing.buyer, tokenId);

        uint256 amount = listing.purchasePrice - marketplaceCommission - transferTax;
        s_sellerProceeds[listing.seller][listing.currency] += amount;

        emit RealEstateSold(
            listing.buyer,
            listing.seller,
            listing.tokenId,
            listing.purchaseTime,
            listing.purchasePrice,
            Stage.sold
        );

        delete s_listings[tokenId];
    }

    function _validateIsAllowedCurrency(address _currency) internal view {
        if (currencyRegistry().isAllowed(_currency) == false) {
            revert TruhuisMarketplace__InvalidCurrency(_currency);
        }
    }

    function _validateHasSufficientFunds(address _buyer, address _currency, uint256 _salePrice)
        internal
        view
    {
        uint256 availableFunds = IERC20(_currency).balanceOf(_buyer);

        if (_salePrice > availableFunds) {
            revert TruhuisMarketplace__InsufficientFunds(_salePrice, availableFunds);
        }
    }

    function _validateIsPriceGreaterThanZero(uint256 _price) internal pure {
        if (0 >= _price) {
            revert TruhuisMarketplace__PriceMustBeGreaterThanZero(_price);
        }
    }

    function _validateIsNotAuctionInAction(uint256 _tokenId) internal view {
        if (auction().getStartTime(_tokenId) > 0) { revert TruhuisMarketplace__AuctionIsInAction(_tokenId); }
    }

    function _validateIsListingCurrency(address _currency, uint256 _tokenId) internal view {
        Listing memory listing = s_listings[_tokenId];

        if (listing.currency != _currency) {
            revert TruhuisMarketplace__InvalidCurrency(_currency);
        }
    }

    function _validateIsExistentOffer(address _offerer, uint256 _tokenId) internal view {
        Offer memory offer = s_offers[_tokenId][_offerer];

        if (
            !offer.exists
            || offer.offerer == address(0)
            || offer.currency == address(0)
            || 0 >= offer.price
            || _getNow() > offer.expiry
        ) {
            revert TruhuisMarketplace__OfferNotExists(_offerer, _tokenId);
        }
    }

    function _validateIsNonExistentOffer(address _offerer, uint256 _tokenId) internal view {
        Offer memory offer = s_offers[_tokenId][_offerer];

        if (
            offer.exists
            || offer.offerer != address(0)
            || offer.currency != address(0)
            || offer.price > 0
            || offer.expiry > _getNow()
        ) {
            revert TruhuisMarketplace__OfferAlreadyExists(_offerer, _tokenId);
        }
    }

    function _validateIsExistentListing(uint256 _tokenId) internal view {
        Listing memory listing = s_listings[_tokenId];

        if (
            !listing.exists
            || 0 >= listing.initialPrice
            || listing.currency == address(0)
            || listing.seller == address(0)
        ) {
            revert TruhuisMarketplace__ListingNotExists(_tokenId);
        }
    }

    function _validateIsNonExistentListing(uint256 _tokenId) internal view {
        Listing memory listing = s_listings[_tokenId];

        if (
            listing.exists
            || listing.initialPrice > 0
            || listing.currency != address(0)
            || listing.seller != address(0)
        ) {
            revert TruhuisMarketplace__ListingAlreadyExists(_tokenId);
        }
    }

    function _validateIsOffererMsgSender(address _offerer, address _msgSender) internal pure {
        if (_offerer != _msgSender) {
            revert TruhuisMarketplace__InvalidOfferer(_msgSender, _offerer);
        }
    }

    function _validateIsHuman(address _account) internal view {
        if (!isHuman(_account)) {
            revert TruhuisMarketplace__AccountIsNotHuman(_account);
        }
    }

    function _validateIsNotPropertyOwner(address _account, uint256 _tokenId) internal view {
        if (cadastre().isOwner(_account, _tokenId)) {
            revert TruhuisMarketplace__AccountIsPropertyOwner(_account, _tokenId);
        }
    }

    function _validateIsPropertyOwner(address _account, uint256 _tokenId) internal view {
        if (!cadastre().isOwner(_account, _tokenId)) {
            revert TruhuisMarketplace__AccountIsNotPropertyOwner(_account, _tokenId);
        }
    }

    function _validateSeller(address _seller, uint256 _tokenId) internal view {
        (address transferTaxReceiver, /*uint256 transferTax*/) = cadastre().royaltyInfo(_tokenId, uint256(1));
        address residentContractAddr = stateGovernment(transferTaxReceiver).getResidentContractAddr(_seller);
        bytes3 stateGovernmentCountry = stateGovernment(transferTaxReceiver).getStateGovernmentCountry();

        bool sellerIsRegistered = stateGovernment(transferTaxReceiver).isResidentRegistered(_seller);
        bool sellerIsAllowedToPurchaseRealEstate = resident(residentContractAddr).isAllowedToPurchaseRealEstate(stateGovernmentCountry);

        if (
            !sellerIsRegistered
            || !sellerIsAllowedToPurchaseRealEstate
        ) {
            revert TruhuisMarketplace__SellerIsNotAllowedToPurchaseRealEstate(_seller, _tokenId);
        }
    }

    function _validateBuyer(address _buyer, uint256 _tokenId) internal view {
        (address transferTaxReceiver, /*uint256 transferTax*/) = cadastre().royaltyInfo(_tokenId, uint256(1));
        address residentContractAddr = stateGovernment(transferTaxReceiver).getResidentContractAddr(_buyer);
        bytes3 stateGovernmentCountry = stateGovernment(transferTaxReceiver).getStateGovernmentCountry();

        bool buyerIsRegistered = stateGovernment(transferTaxReceiver).isResidentRegistered(_buyer);
        bool buyerIsAllowedToPurchaseRealEstate = resident(residentContractAddr).isAllowedToPurchaseRealEstate(stateGovernmentCountry);

        if (
            !buyerIsRegistered
            || !buyerIsAllowedToPurchaseRealEstate
        ) {
            revert TruhuisMarketplace__BuyerIsNotAllowedToPurchaseRealEstate(_buyer, _tokenId);
        }
    }
}

