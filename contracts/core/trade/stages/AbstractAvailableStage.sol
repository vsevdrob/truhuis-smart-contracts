// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../../address/TruhuisAddressRegistryAdapter.sol";
import {
    // Enums
    Stage,
    // Structs
    Listing,
    Offer,
    // Errors
    AuctionIsInAction,
    ExpiryMustBeHigherThanNow,
    InvalidCurrency,
    ListingAlreadyExists,
    ListingNotExists,
    MsgSenderIsNotOfferer,
    NotHighestPriceOffer,
    OfferAlreadyExists,
    OfferCurrencyIsNotListingCurrency,
    OfferNotExists,
    PriceMustBeGreaterThanZero
} from "../../../interfaces/ITruhuisMarketplace.sol";


// All functions without implementation must be marked as virtual.

/**
 * @title AbstractAvailableStage
 * @dev _
 */
abstract contract AbstractAvailableStage is TruhuisAddressRegistryAdapter {

    /**
     * @dev _
     */
    event RealEstateListed__AvailableStage(
        address currency,
        address indexed seller,
        uint256 initialPrice,
        uint256 startTime,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     */
    event ListingCancelled__AvailableStage(
        address indexed seller,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     */
    event OfferCreated__AvailableStage(
        address currency,
        address indexed offerer,
        uint256 expiry,
        uint256 price,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     */
    event OfferAccepted__AvailableStage(
        address indexed seller,
        uint256 indexed tokenId,
        address indexed buyer,
        uint256 purchaseTime,
        uint256 purchasePrice
    );

    /**
     * @dev _
     */
    event OfferCancelled__AvailableStage(
        address indexed offerer,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     */
    event MarketplaceOwnerUpdated__AvailableStage(
        address newOwner
    );

    /**
     * @dev _
     */
    event MarketplaceCommissionFractionUpdated__AvailableStage(
        uint256 newCommissionFraction
    );


    ///**
    // * @dev _
    // */
    //function _acceptOffer__AvailableStage(
    //    uint256 _tokenId,
    //    address _offerer
    //) internal virtual;

    /**
     * @dev _
     */
    function _cancelListing__AvailableStage(
        uint256 _tokenId,
        Listing storage _sListing
    ) internal virtual;

    /**
     * @dev _
     */
    function _cancelOffer__AvailableStage(
        uint256 _tokenId,
        Offer storage _sOffer
    ) internal virtual;

    /**
     * @dev _
     */
    function _createOffer__AvailableStage(
        address _currency,
        address _listingCurrency,
        uint256 _expiry,
        uint256 _highestPriceOffer,
        uint256 _priceOffer,
        uint256 _tokenId,
        Listing storage _sListing,
        Offer storage _sOffer
    ) internal virtual;

    /**
     * @dev _
     */
    function _listRealEstate__AvailableStage(
        address _currency,
        uint256 _tokenId,
        uint256 _price,
        Listing storage _sListing
    ) internal virtual;

    /**
     * @dev _
     */
    function _updateListingCurrency__AvailableStage(
        address _newCurrency,
        uint256 _tokenId,
        Listing storage _sListing
    ) internal virtual;

    /**
     * @dev _
     */
    function _updateListingPrice__AvailableStage(
        uint256 _tokenId,
        uint256 _newPrice,
        Listing storage _sListing
    ) internal virtual;
}
