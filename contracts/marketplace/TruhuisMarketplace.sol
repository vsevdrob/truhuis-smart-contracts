// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../address/adapters/TruhuisAddressRegistryAdapter.sol";
import "../../interfaces/ICitizen.sol";

contract TruhuisMarketplace is Ownable, TruhuisAddressRegistryAdapter, ReentrancyGuard {
    enum Status {
        available,
        underNegotiation,
        sold
    }

    struct Listing {
        bool exists;
        Status status;
        address currency;
        uint256 price;
        uint256 listedTime;
        uint256 tokenId;
        address seller;
    }

    struct Offer {
        address currency;
        bool exists;
        uint256 price;
        uint256 deadline;
    }

    uint96 public marketplaceCommissionFraction; // e.g. 100 (1%); 1000 (10%)
    address public marketplaceOwner;

    /// @dev tokenId => buyer => bool
    mapping(uint256 => mapping(address => bool)) public s_isVerifiedBuyer;
    /// @dev tokenId => seller => bool
    mapping(uint256 => mapping(address => bool)) public s_isVerifiedSeller;

    /// @dev tokenId => Listing
    mapping(uint256 => Listing) public s_listings;  
    /// @dev tokenId => offerer => Offer
    mapping(uint256 => mapping(address => Offer)) public s_offers; 

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
        _updateAddressRegistry(_addressRegistry);
    }

    //      *            *                 *                 *
    //          LISTING        LISTING           LISTING
    //      *            *                 *                 *
    
    function listHouse(address _currency, uint256 _tokenId, uint256 _price)
        external
        notListed(_tokenId)
        onlySeller(msg.sender, _tokenId)
    {
        require(isAllowedCurrency(_currency), "invalid currency");

        Listing storage s_listing = s_listings[_tokenId];

        s_listing.exists = true;
        s_listing.status = Status.available;
        s_listing.currency = _currency;
        s_listing.price = _price;
        s_listing.listedTime = _getNow();
        s_listing.seller = msg.sender;
        s_listing.tokenId = _tokenId;
    }

    function updateListing(address _currency, uint256 _tokenId, uint256 _newPrice)
        external
        nonReentrant
        onlySeller(msg.sender, _tokenId)
        listingExists(_tokenId)
    {
        require(_newPrice > 0, "price must be above 0");
        require(isAllowedCurrency(_currency), "invalid currency");
        Listing storage s_listing = s_listings[_tokenId];
        
        s_listing.currency = _currency;
        s_listing.price = _newPrice;
    }

    function cancelListing(uint256 _tokenId)
        external
        nonReentrant
        onlySeller(msg.sender, _tokenId)
        listingExists(_tokenId)
    {
        delete s_listings[_tokenId];
    }

    // PURCHASE

    function buyHouseFrom(address _seller, address _currency, uint256 _tokenId)
        external
        nonReentrant
        onlyBuyer(msg.sender, _tokenId)
        listingExists(_tokenId)
    {
        Listing memory listing = s_listings[_tokenId];
        
        require(isAllowedCurrency(_currency), "invalid currency");
        require(listing.currency == _currency, "currencies are not equal");
        require(hasEnoughFunds(msg.sender, _currency, listing.price), "insufficient funds");

        uint256 marketplaceCommission = getMarketplaceCommission(listing.price);
        _sendMarketplaceCommission(msg.sender, _currency, marketplaceCommission);

        uint256 royaltyCommission = getRoyaltyCommission(_tokenId, listing.price - marketplaceCommission); 
        _sendRoyalty(msg.sender, _currency, _tokenId, royaltyCommission);

        _purchaseHouseFrom(_seller, msg.sender, _currency, listing.price - marketplaceCommission - royaltyCommission);

        _transferNftFrom(_seller, msg.sender, _tokenId);

        _updateHouseSold(_tokenId);
    }

    //      *           *               *               *
    //          OFFER         OFFER           OFFER
    //      *           *               *               *

    function createOffer(
        address _currency,
        uint256 _tokenId,
        uint256 _price,
        uint256 _deadline
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
            currency: _currency,
            exists: true,
            price: _price,
            deadline: _deadline
        });
    }

    function cancelOffer(uint256 _tokenId)
        external
        onlyBuyer(msg.sender, _tokenId)
        listingExists(_tokenId)
    {
        require(isOfferExistent(msg.sender, _tokenId), "offer not exists");
        delete s_offers[_tokenId][msg.sender];
    }

    function acceptOffer(uint256 _tokenId, address _offerer)
        external
        nonReentrant
        onlySeller(msg.sender, _tokenId)
    {
        require(isOfferExistent(_offerer, _tokenId), "offer not exists");
        require(isOfferExpired(_offerer, _tokenId), "offer is expired");
        require(!isAuctionInAction(_tokenId), "auction must be finished first");

        Offer memory offer = s_offers[_tokenId][_offerer];
        Listing memory listing = s_listings[_tokenId];

        require(isAllowedCurrency(offer.currency), "invalid offer currency");
        require(offer.currency == listing.currency, "offer currency is not listing currency");
        require(hasEnoughFunds(_offerer, offer.currency, offer.price), "offerer has insufficient funds");

        uint256 marketplaceCommission = getMarketplaceCommission(offer.price);
        _sendMarketplaceCommission(_offerer, offer.currency, marketplaceCommission);

        uint256 royaltyCommission = getRoyaltyCommission(_tokenId, offer.price - marketplaceCommission); 
        _sendRoyalty(_offerer, offer.currency, _tokenId, royaltyCommission);

        _purchaseHouseFrom(listing.seller, _offerer, offer.currency, offer.price - marketplaceCommission - royaltyCommission);

        _transferNftFrom(listing.seller, _offerer, _tokenId);

        _updateHouseSold(_tokenId);
        delete s_offers[_tokenId][_offerer];
    }

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // UPDATE
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    function updateMarketplaceOwner(address _newOwner)
        external
        onlyOwner
    {
        marketplaceOwner = _newOwner;
    }

    function updateMarketplaceCommissionFraction(uint96 _newFraction)
        external
        onlyOwner
    {
        marketplaceCommissionFraction = _newFraction;
    }


    //function validateItemSold(uint256 _tokenId, address _seller, address _buyer) external onlyMarketplace {}

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // PUBLIC
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    function verifySeller(address _seller, uint256 _tokenId) public {
        if (!s_isVerifiedSeller[_tokenId][_seller]) {
            require(isHuman(_seller), "seller can not be a contract");
            require(isPropertyOwner(_seller, _tokenId), "seller must be the property owner");
            require(areSimilarCountries(_seller, _tokenId), "seller is not from the same country as the property");
            require(isMarketplaceApproved(_seller), "marketplace must be approved");
            require(isAuctionApproved(_seller), "auction must be approved");
            s_isVerifiedSeller[_tokenId][_seller] = true;
        }
    }

    function verifyBuyer(address _buyer, uint256 _tokenId) public {
        if (!s_isVerifiedBuyer[_tokenId][_buyer]) {
            require(isHuman(_buyer), "buyer can not be a contract");
            require(!isPropertyOwner(_buyer, _tokenId), "buyer can not be the property owner");
            require(areSimilarCountries(_buyer, _tokenId), "buyer is not from the same country as the property");
            require(isMarketplaceApproved(_buyer), "marketplace must be approved");
            require(isAuctionApproved(_buyer), "auction must be approved");
            s_isVerifiedBuyer[_tokenId][_buyer] = true;
        }
    }

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // PUBLIC VIEW RETURNS
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    function areSimilarCountries(address _account, uint256 _tokenId) public view returns (bool) {
        bytes3 realEstateCountry = landRegistry().getRealEstateCountry(_tokenId);
        bytes3 citizenship = bytes3(bytes(citizen(_account).citizenship()));
        return realEstateCountry == citizenship;
    }

    function getListedTime(uint256 _tokenId) public view returns (uint256) {
        return s_listings[_tokenId].listedTime;
    }

    function getMarketplaceCommission(uint256 _salePrice) public view returns (uint256) {
        // price = 250000 USDT * (10**18)
        // price * 250 / 10000 = 6250 USDT * (10**18)
        return _salePrice * marketplaceCommissionFraction / 10000;
    }

    function getRoyaltyInfo(uint256 _tokenId, uint256 _salePrice) public view returns (address, uint256) {
        return landRegistry().royaltyInfo(_tokenId, _salePrice);
    }

    function getRoyaltyCommission(uint256 _tokenId, uint256 _salePrice) public view returns (uint256) {
        (, uint256 commission) = landRegistry().royaltyInfo(_tokenId, uint(1));
        return commission;
    }

    function getRoyaltyReceiver(uint256 _tokenId) public view returns (address) {
        (address receiver, ) = landRegistry().royaltyInfo(_tokenId, uint(1));
        return receiver;
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

    function isAuctionApproved(address _account) public view returns (bool) {
        return auction().isAuctionApproved(_account);
    }

    function isListingExistent(uint256 _tokenId) public view returns (bool) {
        return s_listings[_tokenId].exists;
    }
    
    function isMarketplaceApproved(address _account) public view returns (bool) {
        return landRegistry().isApprovedForAll(_account, address(this));
    }

    function isOfferExistent(address _offerer, uint256 _tokenId) public view returns (bool) {
        return s_offers[_tokenId][_offerer].exists;
    }

    function isOfferExpired(address _offerer, uint256 _tokenId) public view returns (bool) {
        return s_offers[_tokenId][_offerer].deadline > _getNow();
    }

    function isPropertyOwner(address _account, uint256 _tokenId) public view returns (bool) {
        return landRegistry().isOwner(_account, _tokenId);
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

    //function _updateHouseAvailable(uint256 _tokenId) private {
    //    Listing storage s_listing = s_listings[_tokenId];
    //    s_listings.status = Status.available;
    //}

    //function _updateHouseUnderNegotiation(uint256 _tokenId) private {
    //    Listing storage s_listing = s_listings[_tokenId];
    //    s_listing.status = Status.underNegotiation;
    //}

    function _updateHouseSold(uint256 _tokenId) private {
        Listing storage s_listing = s_listings[_tokenId];
        s_listing.exists = false;
        s_listing.status = Status.sold;
        delete s_listings[_tokenId];
    }

    function _sendRoyalty(address _buyer, address _currency, uint256 _tokenId, uint256 _amount) private {
        address royaltyReceiver = getRoyaltyReceiver(_tokenId);
        require(royaltyReceiver != address(0) || _amount > 0, "invalid royalty info");
        IERC20(_currency).transferFrom(_buyer, royaltyReceiver, _amount);
    }

    function _sendMarketplaceCommission(address _buyer, address _currency, uint256 _commission) private {
        IERC20(_currency).transferFrom(_buyer, marketplaceOwner, _commission);
    }

    function _purchaseHouseFrom(address _seller, address _buyer, address _currency, uint256 _price) private {
        IERC20(_currency).transferFrom(_buyer, _seller, _price);
    }

    function _transferNftFrom(address _seller, address _buyer, uint256 _tokenId) private {
        IERC721(landRegistry()).transferFrom(_seller, _buyer, _tokenId);
    }
}

