// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

enum Stage {
    NONE,
    /**
     * @notice Owner always can:
     *
     *         v | Transfer marketplace ownership
     *         v | Update marketplace service fee
     */

    /**
     * @notice During availability period
     *
     *         v | * Accept offer
     *         v | Cancel listing
     *         v | Cancel offer
     *         v | Create offer
     *         v | * List real estate
     *         v | * Update listing currency
     *         v | * Update listing price
     */
    AVAILABLE,
    /**
     * @notice During negotiation period
     *
     *         v | * Cancel accepted offer
     *         v | Cancel listing
     *         v | Cancel offer
     *         v | Create offer
     *         X | * Create purchase agreement
     */
    NEGOTIATION,
    /**
     * @dev NFT sold.
     * @dev Purchase agreement is in force.
     */
    SOLD
    /**
     * @notice During after deed of delivery
     *
     *         * Withdraw seller proceeds
     *         * Withdraw transfer taxes
     *         * Withdraw marketplace proceeds
     */
}

struct AcceptedOffer {
    address currency;
    address offerer;
    bool exists;
    uint256 offerId;
    uint256 price;
    uint256 timeAccepted;
}

struct Listing {
    address currency;
    address seller;
    bool exists;
    uint256 endTime;
    uint256 initialPrice;
    uint256 startTime;
    uint256 tokenId;
    AcceptedOffer acceptedOffer;
    Stage stage;
}

struct Offer {
    address currency;
    address offerer;
    bool exists;
    uint256 expiry;
    uint256 price;
}

error ACCEPTED_OFFER_NOT_EXISTS();
error ACCEPTED_OFFER_EXISTS();

///// @notice Reverted if `account` is equal to actual `tokenId` property owner.
//error AccountIsPropertyOwner(address account, uint256 tokenId);
///// @notice Reverted if `account` is not equal to actual `tokenId` property owner.
//error AccountIsNotPropertyOwner(address account, uint256 tokenId);
///// @notice Reverted if `account` is a smart contract, not an account (human).
error CALLER_NOT_HUMAN(address account);
error CALLER_NOT_NOTARY();

/// @notice Reverted if an auction for a provided token ID didn't finish yet.
error AUCTION_IN_ACTION(uint256 tokenId);

error EXPIRY_NOT_HIGHER_THAN_NOW(uint256 timeNow, uint256 expiry);
error IDENTICAL_SERVICE_FEE_PROVIDED();
/// @notice Reverted if an ERC-20 currency is unsupported by the marketplace.
error INVALID_CURRENCY(address invalidCurrency);

error INVALID_OFFER_CURRENCY(address offerCurrency, address listingCurrency);
error INVALID_STAGE(Stage required, Stage current);

///// @notice Reverted if a Real Estate purchase is failed.
//error RealEstatePurchaseFailed();
/// @notice Reverted if a price is less than zero or equal to zero.
error PRICE_NOT_GREATER_THAN_ZERO();
///// @notice Reverted if a buyer has insufficient funds to purhcase a property.
//error InsufficientFunds(uint256 salePrice, uint256 avaliableFunds);

///// @notice Reverted if `msgSender` is not equal to `required` message sender.
//error InvalidMsgSender(address msgSender, address required);
///// @notice Reverted if `current` listing stage is not equal to `required` listing stage.
//error InvalidListingStage(Stage current, Stage required);
//error InvalidListing(uint256 tokenId);
//error InvalidOffer(address offerer, uint256 tokenId);

/// @notice Reverted if a provided offer already exists.
error OFFER_ALREADY_EXISTS(address offerer, uint256 tokenId);
/// @notice Reverted if a provided offer is non-existent.
error OFFER_NOT_EXISTS(address offerer, uint256 offerId, uint256 tokenId);
///// @notice Reverted if a provided offer is expired.
//error OfferIsExpired(address offerer, uint256 tokenId);
error OFFER_EXPIRED(address offerer, uint256 offerId, uint256 tokenId);
error OFFER_ACCEPTED(address offerer, uint256 offerId, uint256 tokenId);

error CALLER_NOT_OFFERER(address caller, address offerer);

/// @notice Reverted if a provided listing is non-existent.
error LISTING_NOT_EXISTS(uint256 tokenId);
/// @notice Reverted if a provided listing alrady exists.
error LISTING_ALREADY_EXISTS(uint256 tokenId);
///// @notice Reverted if a listing not at available stage.
//error ListingMustBeAtAvailableStage();
error STAGE_SOLD();

///// @notice Reverted if marketplace owner update fails.
//error MarketplaceOwnerUpdateFailed();
///// @notice Reverted if marketplace service fee update fails.
//error MarketplaceServiceFeeUpdateFailed();

///// @notice Reverted if marketplace is not approved to transfer `tokenId`.
//error MarketplaceIsNotApproved(uint256 tokenId);

/// Price
//error NotHighestPriceOffer(uint256 highestPriceOffer, uint256 madePriceOffer);

///// @notice Reverted if `buyer` is not allowed to purchase `tokenId` Real Estate.
//error BuyerIsNotAllowedToPurchaseRealEstate(address buyer, uint256 tokenId);
///// @notice Reverted if `seller` is not allowed to sell `tokenId` Real Estate.
//error SellerIsNotAllowedToSellRealEstate(address seller, uint256 tokenId);
/// @notice Reverted if purchase cancelation of `tokenId` Real Estate fails.
//error UnableToCancelPurchase(uint256 tokenId);

interface ITruhuisMarketplace {
    /**
     * @dev _
     * NOTE: Negotiation stage
     */
    event AcceptedOfferCancelled(
        address indexed offerer,
        uint256 indexed offerId,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     * NOTE: Available stage & negotiation stage.
     */
    event ListingCancelled(address indexed seller, uint256 indexed tokenId);

    /**
     * @dev _
     * NOTE: Available stage.
     */
    event OfferAccepted(
        address indexed buyer,
        uint256 indexed offerId,
        uint256 timeAccepted,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     * NOTE: Available stage & negotiation stage.
     */
    event OfferCancelled(
        address indexed offerer,
        uint256 offerId,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     * NOTE: Available stage & negotiation stage.
     */
    event OfferCreated(
        address currency,
        address indexed offerer,
        uint256 expiry,
        uint256 offerId,
        uint256 price,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     * NOTE: Available stage.
     */
    event Listed(
        address currency,
        address indexed seller,
        uint256 initialPrice,
        uint256 startTime,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     */
    event ServiceFeeUpdated(uint96 newServiceFee, uint96 oldServiceFee);

    /**
     * @dev _
     */
    event Sold(uint256 _tokenId);

    /**
     * @dev _
     * NOTE: Available stage.
     */
    function acceptOffer(
        address _offerer,
        uint256 _offerId,
        uint256 _tokenId
    ) external;

    /**
     * @dev _
     * NOTE: Negotiation stage.
     */
    function cancelAcceptedOffer(uint256 _tokenId) external;

    /**
     * @dev _
     * NOTE: Available stage & negotiation stage.
     */
    function cancelListing(uint256 _tokenId) external;

    /**
     * @dev _
     * NOTE: Available stage & negotiation stage.
     */
    function cancelOffer(uint256 _offerId, uint256 _tokenId) external;

    /**
     * @dev _
     * NOTE: Available stage & negotiation stage.
     */
    function createOffer(
        address _currency,
        uint256 _expiry,
        uint256 _price,
        uint256 _tokenId
    ) external;

    /**
     * @dev _
     * NOTE: Available stage.
     */
    function list(
        address _currency,
        uint256 _price,
        uint256 _tokenId
    ) external;

    /**
     * @dev _
     * NOTE: Negotiation stage.
     */
    function setListingSold(uint256 _tokenId) external;

    /**
     * @dev _
     * NOTE: Available stage.
     */
    function updateListingCurrency(address _newCurrency, uint256 _tokenId)
        external;

    /**
     * @dev _
     * NOTE: Available stage.
     */
    function updateListingPrice(uint256 _newPrice, uint256 _tokenId) external;

    /**
     * @dev Update marketplace service fee.
     * @param _newServiceFee The new marketplace service fee.
     */
    function updateServiceFee(uint96 _newServiceFee) external;

    /**
     * @dev _
     */
    function getListing(uint256 _tokenId)
        external
        view
        returns (Listing memory);

    ///**
    // * @dev Update marketplace owner address.
    // * @param _newOwner The new marketplace owner address.
    // */
    //function updateMarketplaceOwner(address _newOwner) external;

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

    //event MarketplaceServiceFeeUpdated(uint256 newServiceFee);

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
