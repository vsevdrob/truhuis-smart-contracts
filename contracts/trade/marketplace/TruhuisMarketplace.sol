// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../../address/adapters/TruhuisAddressRegistryAdapter.sol";
import "../../../interfaces/IStateGovernment.sol";
import "../../../interfaces/ICitizen.sol";

contract TruhuisMarketplace is
    Ownable,
    TruhuisAddressRegistryAdapter,
    ReentrancyGuard,
    KeeperCompatibleInterface
{
    enum Stage {
        available,
        negotiation, // @dev Ontbindende voorwaarden opstellen. Vereist aparte contract.
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

    address public marketplaceOwner;
    uint96 public marketplaceCommissionFraction; // e.g. 100 (1%); 1000 (10%)

    /// @dev tokenId => buyer => bool
    mapping(uint256 => mapping(address => bool)) public s_isVerifiedBuyer;
    /// @dev tokenId => seller => bool
    mapping(uint256 => mapping(address => bool)) public s_isVerifiedSeller;

    /// @dev tokenId => Listing
    mapping(uint256 => Listing) public s_listings;  
    /// @dev tokenId => offerer => Offer
    mapping(uint256 => mapping(address => Offer)) public s_offers; 

    /// @dev seller => currency => seller proceeds allowed to withdraw
    mapping(address => mapping(address => uint256)) public s_sellerProceeds;
    /// @dev transferTaxReceiver => currency => transfer taxes allowed to withdraw
    mapping(address => mapping(address => uint256)) public s_transferTaxes;
    /// @dev currency => marketplace proceeds allowed to withdraw
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

    event ListingUpdated(
        address indexed seller,
        uint256 indexed tokenId,
        address currency,
        uint256 newPrice
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
        address oldOwner,
        address newOwner
    );

    event MarketplaceCommissionFractionUpdated(
        uint256 oldCommissionFraction,
        uint256 newCommissionFraction
    );

    modifier listingExists(uint256 _tokenId) {
        require(isListingExistent(_tokenId), "listing must be existent");
        _;
    }

    modifier notListed(uint256 _tokenId) {
        require(!isListingExistent(_tokenId), "listing must be nonexistent");
        _;
    }

    modifier notOffered(address _offerer, uint256 _tokenId) {
        require(!isOfferExistent(_offerer, _tokenId), "offer must be nonexistent");
        _;
    }

    modifier onlyBuyer(address _buyer, uint256 _tokenId) {
        verifyBuyer(_buyer, _tokenId);
        _;
    }

    modifier onlySeller(address _seller, uint256 _tokenId) {
        verifySeller(_seller, _tokenId);
        _;
    }

    constructor(address _addressRegistry) {
        marketplaceOwner = msg.sender;
        marketplaceCommissionFraction = 250; 
        _updateAddressRegistry(_addressRegistry);
    }

    //      *            *                 *                 *
    //          LISTING        LISTING           LISTING
    //      *            *                 *                 *
    
    function listRealEstate(address _currency, uint256 _tokenId, uint256 _price)
        external
        notListed(_tokenId)
        onlySeller(msg.sender, _tokenId)
    {
        require(isAllowedCurrency(_currency), "invalid currency");

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

        bytes3 propertyCountry = getPropertyCountry(_tokenId);

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

    function purchaseRealEstate(address _seller, address _currency, uint256 _tokenId)
        external
        nonReentrant
        onlyBuyer(msg.sender, _tokenId)
        listingExists(_tokenId)
    {
        Listing storage s_listing = s_listings[_tokenId];
        
        require(isAllowedCurrency(_currency), "invalid currency");
        require(s_listing.currency == _currency, "currencies are not equal");
        require(hasEnoughFunds(msg.sender, _currency, s_listing.initialPrice), "insufficient funds");

        s_listing.buyer = msg.sender;
        s_listing.purchasePrice = s_listing.initialPrice;
        s_listing.purchaseTime = block.timestamp;

        _purchaseRealEstate(msg.sender, _currency, _tokenId, s_listing.initialPrice);

        emit RealEstatePurchased(
            msg.sender,
            _seller,
            _tokenId,
            s_listing.purchaseTime,
            s_listing.purchasePrice,
            Stage.coolingOffPeriod
        );
    }

    function updateListing(address _currency, uint256 _tokenId, uint256 _newPrice)
        external
        onlySeller(msg.sender, _tokenId)
        listingExists(_tokenId)
    {
        require(_newPrice > 0, "price must be above 0");
        require(isAllowedCurrency(_currency), "invalid currency");

        Listing storage s_listing = s_listings[_tokenId];
        
        s_listing.currency = _currency;
        s_listing.initialPrice = _newPrice;

        emit ListingUpdated(
            msg.sender,
            _tokenId,
            _currency,
            _newPrice
        );
    }

    function cancelListing(uint256 _tokenId)
        external
        onlySeller(msg.sender, _tokenId)
        listingExists(_tokenId)
    {
        delete s_listings[_tokenId];

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
        listingExists(_tokenId)
        notOffered(msg.sender, _tokenId)
    {
        require(_price > 0, "price must be greater than zero");
        require(isOfferExistent(msg.sender, _tokenId), "offer not exists");
        require(isOfferExpired(msg.sender, _tokenId), "offer is expired");
        require(isAllowedCurrency(_currency), "invalid currency");
        require(isAuctionInAction(_tokenId), "auction must be finished first");

        s_offers[_tokenId][msg.sender] = Offer({
            offerer: msg.sender,
            currency: _currency,
            exists: true,
            price: _price,
            expiry: _expiry
        });

        emit OfferCreated(
            msg.sender,
            _tokenId,
            _currency,
            _price,
            _expiry
        );
    }

    /**
     * @notice Seller accepts the offer.
     */
    function acceptOffer(uint256 _tokenId, address _offerer)
        external
        nonReentrant
        onlySeller(msg.sender, _tokenId)
    {
        require(isOfferExistent(_offerer, _tokenId), "offer not exists");
        require(isOfferExpired(_offerer, _tokenId), "offer is expired");
        require(!isAuctionInAction(_tokenId), "auction must be finished first");

        Offer memory offer = s_offers[_tokenId][_offerer];
        Listing storage s_listing = s_listings[_tokenId];

        require(isAllowedCurrency(offer.currency), "invalid offer currency");
        require(offer.currency == s_listing.currency, "offer currency is not listing currency");
        require(hasEnoughFunds(_offerer, offer.currency, offer.price), "offerer has insufficient funds");

        s_listing.buyer = _offerer;
        s_listing.purchasePrice = offer.price;
        s_listing.purchaseTime = block.timestamp;

        _purchaseRealEstate(_offerer, offer.currency, _tokenId, offer.price);

        emit OfferAccepted(
            s_listing.seller,
            _tokenId,
            msg.sender,
            s_listing.purchaseTime,
            s_listing.purchasePrice,
            Stage.coolingOffPeriod
        );

        delete s_offers[_tokenId][_offerer];
    }

    function cancelOffer(uint256 _tokenId)
        external
        onlyBuyer(msg.sender, _tokenId)
        listingExists(_tokenId)
    {
        Offer memory offer = s_offers[_tokenId][msg.sender];

        require(offer.offerer == msg.sender, "invalid offerer");
        require(isOfferExistent(msg.sender, _tokenId), "offer not exists");

        delete s_offers[_tokenId][msg.sender];

        emit OfferCanceled(
            msg.sender,
            _tokenId
        );
    }

    /**
     * @notice Buyer changed his/her mind during cooling-off period.
     */
    function cancelPurchase(uint256 _tokenId)
        external
        nonReentrant
        onlyBuyer(msg.sender, _tokenId)
        listingExists(_tokenId)
    {
        Listing memory listing = s_listings[_tokenId];

        require(listing.buyer == msg.sender, "invalid buyer");
        require(listing.status == Stage.coolingOffPeriod, "real estate wasn't purchased");
        require(listing.exists, "nonexistent listing");

        address currency = listing.currency;
        uint256 purchasePrice = listing.purchasePrice;

        delete s_listings[_tokenId].buyer;
        delete s_listings[_tokenId].purchasePrice;
        delete s_listings[_tokenId].purchaseTime;

        require(IERC20(currency).transfer(msg.sender, purchasePrice), "purchase cancelation error");

        emit PurchaseCanceled(
            msg.sender,
            _tokenId,
            Stage.available
        );
    }

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // UPDATE ONLY OWNER
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    function updateMarketplaceOwner(address _newOwner)
        external
        onlyOwner
    {
        address oldOwner = marketplaceOwner;
        marketplaceOwner = _newOwner;
        
        emit MarketplaceOwnerUpdated(
            oldOwner,
            _newOwner
        );
    }

    function updateMarketplaceCommissionFraction(uint96 _newCommissionFraction)
        external
        onlyOwner
    {
        uint256 oldCommissionFraction = marketplaceCommissionFraction;
        marketplaceCommissionFraction = _newCommissionFraction;

        emit MarketplaceCommissionFractionUpdated(
            oldCommissionFraction,
            _newCommissionFraction
        );
    }

    function withdrawTransferTaxes(address _currency) external {
        uint256 transferTaxes = s_transferTaxes[msg.sender][_currency];

        require(transferTaxes > 0, "no transfer taxes");

        s_transferTaxes[msg.sender][_currency] = 0;

        require(IERC20(_currency).transfer(msg.sender, transferTaxes), "failed to withdraw transfer taxes");
    }

    function withdrawSellerProceeds(address _currency) external {
        uint256 proceeds = s_sellerProceeds[msg.sender][_currency];
        
        require(proceeds > 0, "no proceeds");

        s_sellerProceeds[msg.sender][_currency] = 0;
        
        require(IERC20(_currency).transfer(msg.sender, proceeds), "failed to withdraw proceeds");
    }

    function withdrawMarketplaceProceeds(address _currency) external {
        require(msg.sender == marketplaceOwner, "not marketplace owner");

        uint256 marketplaceProceeds = s_marketplaceProceeds[_currency];

        require(marketplaceProceeds > 0, "no marketplace proceeds");

        s_marketplaceProceeds[_currency] = 0;

        require(IERC20(_currency).transfer(marketplaceOwner, marketplaceProceeds), "failed to withdraw marketplace proceeds");
    }

    //function validateItemSold(uint256 _tokenId, address _seller, address _buyer) external onlyAuction {}

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // PUBLIC
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    /**
     * @notice Seller verification process.
     */
    function verifySeller(address _seller, uint256 _tokenId) public {
        if (!s_isVerifiedSeller[_tokenId][_seller]) {
            require(isHuman(_seller), "seller can not be a contract");
            require(isPropertyOwner(_seller, _tokenId), "seller must be the property owner");
            require(areSimilarCountries(_seller, _tokenId), "seller is not from the same country as the property");
            require(isMarketplaceApproved(_tokenId), "marketplace must be approved");
            //require(isAuctionApproved(_seller), "auction must be approved");
            s_isVerifiedSeller[_tokenId][_seller] = true;
        }
    }

    /**
     * @notice Buyer verification process.
     */
    function verifyBuyer(address _buyer, uint256 _tokenId) public {
        if (!s_isVerifiedBuyer[_tokenId][_buyer]) {
            require(isHuman(_buyer), "buyer can not be a contract");
            require(!isPropertyOwner(_buyer, _tokenId), "buyer can not be the property owner");
            require(areSimilarCountries(_buyer, _tokenId), "buyer is not from the same country as the property");
            require(isMarketplaceApproved(_tokenId), "marketplace must be approved");
            //require(isAuctionApproved(_buyer), "auction must be approved");
            s_isVerifiedBuyer[_tokenId][_buyer] = true;
        }
    }

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // PUBLIC VIEW RETURNS
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    /**
     * @notice Check whether `_account` and `_tokenId` can be relatered to the similar State Government.
     */
    function areSimilarCountries(address _account, uint256 _tokenId) public view returns (bool) {
        (address transferTaxReceiver, uint256 transferTax) = cadastre().royaltyInfo(_tokenId, uint256(1));
        bool isRegistered = IStateGovernment(transferTaxReceiver).getIsCitizenContractRegistered(_account);
        return isRegistered;
    }

    /**
     * @dev During cooling-off period the buyer can verify himself as the new potential property owner.
     */
    function getBuyer(uint256 _tokenId) public view returns (address) {
        require(isListingExistent(_tokenId), "nonexistent listing");
        return s_listings[_tokenId].buyer;
    }

    function getCoolingOffPeriod(uint256 _tokenId) public view returns (uint256) {
        (address stateGov,) = cadastre().royaltyInfo(_tokenId, uint256(1));
        uint256 coolingOffPeriod = IStateGovernment(stateGov).getCoolingOffPeriod();
        return coolingOffPeriod;
    }

    function getInitialTime(uint256 _tokenId) public view returns (uint256) {
        return s_listings[_tokenId].initialTime;
    }

    function getListing(uint256 _tokenId) public view returns (Listing memory) {
        return s_listings[_tokenId];
    }

    function getMarketplaceCommission(uint256 _salePrice) public view returns (uint256) {
        // price = 250000 USDT * (10**18)
        // price * 250 / 10000 = 6250 USDT * (10**18)
        return _salePrice * marketplaceCommissionFraction / 10000;
    }

    function getPropertyCountry(uint256 _tokenId) public view returns (bytes3) {
        (address stateGovernment,) = cadastre().royaltyInfo(_tokenId, uint256(1));
        bytes3 country = IStateGovernment(stateGovernment).getCountry();
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
        require(areSimilarCountries(_buyer, _tokenId), "buyer must be from the same country as the property");
        (address transferTaxReceiver, uint256 transferTax) = cadastre().royaltyInfo(_tokenId, _salePrice);
        require(transferTaxReceiver != address(0) && transferTax > 0, "invalid transfer tax information");
        return (transferTaxReceiver, transferTax);
    }

    function isAuctionInAction(uint256 _tokenId) public view returns (bool) {
        return auction().getStartTime(_tokenId) > 0;
    }

    function hasEnoughFunds(address _buyer, address _currency, uint256 _salePrice) public view returns (bool) {
        return IERC20(_currency).balanceOf(_buyer) > _salePrice ? true : false;
    }

    function isHuman(address _account) public view returns (bool) {
        uint256 codeLength;
        assembly {codeLength := extcodesize(_account)}
        return codeLength == 0 && _account != address(0);
    }

    function isAllowedCurrency(address _currency) public view returns (bool) {
        return currencyRegistry().isAllowed(_currency);
    }

    //function isAuctionApproved(address _account) public view returns (bool) {
    //    return cadastre().getApproved(_tokenId) == address(auction());
    //}

    function isListingExistent(uint256 _tokenId) public view returns (bool) {
        return s_listings[_tokenId].exists;
    }
    
    function isMarketplaceApproved(uint256 _tokenId) public view returns (bool) {
        return cadastre().getApproved(_tokenId) == address(this);
    }

    function isOfferExistent(address _offerer, uint256 _tokenId) public view returns (bool) {
        return s_offers[_tokenId][_offerer].exists;
    }

    function isOfferExpired(address _offerer, uint256 _tokenId) public view returns (bool) {
        return s_offers[_tokenId][_offerer].expiry > _getNow();
    }

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

    function _purchaseRealEstate(address _buyer, address _currency, uint256 _tokenId, uint256 _price) private {
        s_listings[_tokenId].status = Stage.coolingOffPeriod;
        require(IERC20(_currency).transferFrom(_buyer, address(this), _price), "failed to purchase real estate");
    }

    function _transferNftFrom(address _seller, address _buyer, uint256 _tokenId) private {
        IERC721(cadastre()).transferFrom(_seller, _buyer, _tokenId);
    }

    function checkUpkeep(bytes calldata _checkData)
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData) {
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
        require(isListingExistent(tokenId), "invalid listing");
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
}

