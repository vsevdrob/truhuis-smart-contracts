// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../../address/TruhuisAddressRegistryAdapter.sol";
import {
    Listing,
    Offer,
    AuctionIsInAction,
    ExpiryMustBeHigherThanNow,
    InvalidCurrency,
    ListingAlreadyExists,
    ListingNotExists,
    MsgSenderIsNotOfferer,
    OfferAlreadyExists,
    OfferCurrencyIsNotListingCurrency,
    OfferNotExists,
    PriceMustBeGreaterThanZero
} from "../../../interfaces/ITruhuisMarketplace.sol";

/**
 * @title AbstractAvailableStage
 * @author _
 * @dev _
 */
abstract contract AbstractAvailableStage is TruhuisAddressRegistryAdapter {
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
    event OfferAccepted__AvailableStage(
        address indexed buyer,
        uint256 indexed offerId,
        uint256 timeAccepted,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     */
    event OfferCancelled__AvailableStage(
        address indexed offerer,
        uint256 offerId,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     */
    event OfferCreated__AvailableStage(
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
    function _acceptOffer__AvailableStage(
        address _offerer,
        uint256 _offerId,
        Listing storage _sListing
    ) internal virtual;

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
        uint256 _offerId,
        Listing storage _sListing
    ) internal virtual;

    /**
     * @dev _
     */
    function _createOffer__AvailableStage(
        address _currency,
        uint256 _expiry,
        uint256 _price,
        uint256 _tokenId,
        Listing storage _sListing
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
