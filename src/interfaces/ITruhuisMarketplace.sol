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
    uint256 bidPrice;
    uint256 offerId;
    uint256 timeAccepted;
}

struct Listing {
    address currency;
    address seller;
    bool exists;
    uint256 askPrice;
    uint256 endTime;
    uint256 startTime;
    uint256 tokenId;
    AcceptedOffer acceptedOffer;
    Stage stage;
}

struct Offer {
    address currency;
    address offerer;
    bool exists;
    uint256 bidPrice;
    uint256 expiry;
}

error ACCEPTED_OFFER_NOT_EXISTS();
error ACCEPTED_OFFER_EXISTS();

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

/// @notice Reverted if a price is less than zero or equal to zero.
error PRICE_NOT_GREATER_THAN_ZERO();
/// @notice Reverted if a provided offer already exists.
error OFFER_ALREADY_EXISTS(address offerer, uint256 tokenId);
/// @notice Reverted if a provided offer is non-existent.
error OFFER_NOT_EXISTS(address offerer, uint256 offerId, uint256 tokenId);
error OFFER_EXPIRED(address offerer, uint256 offerId, uint256 tokenId);
error OFFER_ACCEPTED(address offerer, uint256 offerId, uint256 tokenId);

error CALLER_NOT_OFFERER(address caller, address offerer);

/// @notice Reverted if a provided listing is non-existent.
error LISTING_NOT_EXISTS(uint256 tokenId);
/// @notice Reverted if a provided listing alrady exists.
error LISTING_ALREADY_EXISTS(uint256 tokenId);
error STAGE_SOLD();

interface ITruhuisMarketplace {
    /**
     * @dev _
     */
    event AcceptedOfferCancelled(
        address indexed offerer,
        uint256 indexed offerId,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     */
    event ListingCancelled(address indexed seller, uint256 indexed tokenId);

    /**
     * @dev _
     */
    event OfferAccepted(
        address indexed buyer,
        uint256 indexed offerId,
        uint256 timeAccepted,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     */
    event OfferCancelled(
        address indexed offerer,
        uint256 offerId,
        uint256 indexed tokenId
    );

    /**
     * @dev _
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
     */
    function acceptOffer(
        address _offerer,
        uint256 _offerId,
        uint256 _tokenId
    ) external;

    /**
     * @dev _
     */
    function cancelAcceptedOffer(uint256 _tokenId) external;

    /**
     * @dev _
     */
    function cancelListing(uint256 _tokenId) external;

    /**
     * @dev _
     */
    function cancelOffer(uint256 _offerId, uint256 _tokenId) external;

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
    function list(
        address _currency,
        uint256 _price,
        uint256 _tokenId
    ) external;

    /**
     * @dev _
     */
    function setListingSold(uint256 _tokenId) external;

    /**
     * @dev _
     */
    function updateListingCurrency(address _newCurrency, uint256 _tokenId)
        external;

    /**
     * @dev _
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

    /**
     * @dev _
     */
    function getServiceFee() external view returns (uint96);
}
