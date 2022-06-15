// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

// Can always:
// - Update Marketplace Owner
// - Update Marketplace Commission Fraction
enum Stage {
    // - List Real Estate X
    // ! Create Offer
    // ! Create Offer
    // ! Create Offer X
    //      !! Accept Offer -> 
    // - Update Listing Currency X
    // - Update Listing Price X
    // - Cancel Offer X
    // - Cancel Listing X
    available,
    // ! Create Offer
    //      !! Accept Offer
    // - Update Listing Currency
    // - Update Listing Price
    // - Cancel Offer
    // - Cancel Listing
    //
    // - Set Purchase Agreement,
        // - Transfer ERC721 to Bank
        // - Transfer ERC20 to Bank
    negotiation,
    // - Cancel Purchase
    coolingOffPeriod,
    // - Cancel Purchase
    resolutiveConditions,
    // - Transfer ERC721
    // - Transfer ERC20
    deedOfDelivery
    // - Withdraw Marketplace Proceeds
    // - Withdraw Transfer Taxes
    // - Withdraw Seller Proceeds
}


struct Listing {
    address buyer;
    address currency;
    address purchaseAgreement;
    address seller;
    bool exists;
    mapping(address => Offer) offer;
    Stage stage;
    uint256 endTime;
    uint256 highestPriceOffer;
    uint256 initialPrice;
    uint256 startTime;
    //uint256 purchasePrice;
    //uint256 purchaseTime;
    uint256 tokenId;
}

struct Offer {
    address currency;
    address offerer;
    bool exists;
    uint256 expiry;
    uint256 price;
    uint256 tokenId;
}

///// @notice Reverted if `account` is equal to actual `tokenId` property owner.
//error AccountIsPropertyOwner(address account, uint256 tokenId);
///// @notice Reverted if `account` is not equal to actual `tokenId` property owner.
//error AccountIsNotPropertyOwner(address account, uint256 tokenId);
///// @notice Reverted if `account` is a smart contract, not an account (human).
error AccountMustBeHuman(address account);

/// @notice Reverted if a Real Estate purchase is failed.
error RealEstatePurchaseFailed();
/// @notice Reverted if an auction for a provided token ID didn't finish yet.
error AuctionIsInAction(uint256 tokenId);
/// @notice Reverted if a price is less than zero or equal to zero.
error PriceMustBeGreaterThanZero();
/// @notice Reverted if a buyer has insufficient funds to purhcase a property.
error InsufficientFunds(uint256 salePrice, uint256 avaliableFunds);

/// @notice Reverted if an ERC-20 currency is unsupported by the marketplace.
error InvalidCurrency(address invalidCurrency);
/// @notice Reverted if `msgSender` is not equal to `required` message sender.
error InvalidMsgSender(address msgSender, address required);
/// @notice Reverted if `current` listing stage is not equal to `required` listing stage.
error InvalidListingStage(Stage current, Stage required);
//error InvalidListing(uint256 tokenId);
//error InvalidOffer(address offerer, uint256 tokenId);

/// @notice Reverted if a provided offer already exists.
error OfferAlreadyExists(address offerer, uint256 tokenId);
/// @notice Reverted if a provided offer is non-existent.
error OfferNotExists(address offerer, uint256 tokenId);
/// @notice Reverted if a provided offer is expired.
error OfferIsExpired(address offerer, uint256 tokenId);

error MsgSenderIsNotOfferer(address msgSender, address offerer);

/// @notice Reverted if a provided listing is non-existent.
error ListingNotExists(uint256 tokenId);
/// @notice Reverted if a provided listing alrady exists.
error ListingAlreadyExists(uint256 tokenId);
/// @notice Reverted if a listing not at available stage.
error ListingMustBeAtAvailableStage();

/// @notice Reverted if marketplace owner update fails.
error MarketplaceOwnerUpdateFailed();
/// @notice Reverted if marketplace commission fraction update fails.
error MarketplaceCommissionFractionUpdateFailed();
///// @notice Reverted if marketplace is not approved to transfer `tokenId`.
//error MarketplaceIsNotApproved(uint256 tokenId);

/// Price
error NotHighestPriceOffer(uint256 highestPriceOffer, uint256 madePriceOffer);

error OfferCurrencyIsNotListingCurrency(address offerCurrency, address listingCurrency);

error ExpiryMustBeHigherThanNow(uint256 timeNow, uint256 expiry);

///// @notice Reverted if `buyer` is not allowed to purchase `tokenId` Real Estate.
//error BuyerIsNotAllowedToPurchaseRealEstate(address buyer, uint256 tokenId);
///// @notice Reverted if `seller` is not allowed to sell `tokenId` Real Estate.
//error SellerIsNotAllowedToSellRealEstate(address seller, uint256 tokenId);
/// @notice Reverted if purchase cancelation of `tokenId` Real Estate fails.
error UnableToCancelPurchase(uint256 tokenId);


interface ITruhuisMarketplace {


    /**
     * @dev _
     */
     function cancelListing(uint256 _tokenId) external;

    /**
     * @dev _
     */
     function cancelOffer(uint256 _tokenId) external;
    
    /**
     * @dev _
     */
    function createOffer(
        address _currency,
        uint256 _expiry,
        uint256 _price,
        uint256 _tokenId
    ) external;

    /**
     * @dev _
     */
    function listRealEstate(
        address _currency,
        uint256 _tokenId,
        uint256 _price
    ) external;

    /**
     * @dev _
     */
    function updateListingCurrency(address _currency, uint256 _tokenId)
        external;

    /**
     * @dev _
     */
    function updateListingPrice(uint256 _tokenId, uint256 _newPrice)
        external;



    //event RealEstateListed(
    //    address indexed seller,
    //    uint256 indexed tokenId,
    //    bytes3 indexed propertyCountry,
    //    address currency,
    //    uint256 initialTime,
    //    uint256 initialPrice,
    //    uint256 coolingOffPeriod,
    //    Stage stage
    //);

    //event RealEstatePurchased(
    //    address indexed buyer,
    //    address indexed seller,
    //    uint256 indexed tokenId,
    //    uint256 purchaseTime,
    //    uint256 purchasePrice,
    //    Stage stage
    //);

    //event RealEstateSold(
    //    address indexed buyer,
    //    address indexed seller,
    //    uint256 indexed tokenId,
    //    uint256 soldTime,
    //    uint256 soldPrice,
    //    Stage stage
    //);

    //event ListingCanceled(
    //    address indexed seller,
    //    uint256 indexed tokenId
    //);

    //event OfferCreated(
    //    address indexed offerer,
    //    uint256 indexed tokenId,
    //    address currency,
    //    uint256 price,
    //    uint256 expiry
    //);

    //event OfferAccepted(
    //    address indexed seller,
    //    uint256 indexed tokenId,
    //    address indexed buyer,
    //    uint256 purchaseTime,
    //    uint256 purchasePrice,
    //    Stage stage
    //);

    //event OfferCanceled(
    //    address indexed offerer,
    //    uint256 indexed tokenId
    //);

    //event PurchaseCanceled(
    //    address indexed buyer,
    //    uint256 indexed tokenId,
    //    Stage stage
    //);

    //event MarketplaceOwnerUpdated(
    //    address newOwner
    //);

    //event MarketplaceCommissionFractionUpdated(
    //    uint256 newCommissionFraction
    //);

    //event SellerProceedsWithdrew(
    //    address indexed seller,
    //    address indexed currency,
    //    uint256 indexed sellerProceeds
    //);

    //event TransferTaxesWithdrew(
    //    address indexed transferTaxReceiver,
    //    address indexed currency,
    //    uint256 indexed transferTaxes
    //);

    //event MarketplaceProceedsWithdrew(
    //    address indexed currency,
    //    uint256 indexed marketplaceProceeds
    //);


    //function verifySeller(address _seller, uint256 _tokenId) external;
    //function verifyBuyer(address _buyer, uint256 _tokenId) external;
    //function getMarketplaceCommission(uint256 _salePrice) external view returns (uint256);

    //function getRoyaltyCommission(uint256 _tokenId, uint256 _salePrice) external view returns (uint256);
    //function getRoyaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address, uint256);
    //function getRoyaltyReceiver(uint256 _tokenId) external view returns (address);

    //function hasEnoughFunds(address _account, address _currency, uint256 _amount) external view returns (bool);

    //function isHuman(address _account) external view returns (bool);

    //function isVerifiedBuyer(address _buyer, uint256 _tokenId) external view returns (bool);

    //function isVerifiedSeller(address _seller, uint256 _tokenId) external view returns (bool);

}
