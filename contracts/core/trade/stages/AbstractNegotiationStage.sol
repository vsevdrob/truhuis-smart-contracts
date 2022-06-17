// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../../address/TruhuisAddressRegistryAdapter.sol";
import {
    Listing,
    Offer,
    AcceptedOfferNotExists,
    AuctionIsInAction,
    ExpiryMustBeHigherThanNow,
    ListingNotExists,
    MsgSenderIsNotOfferer,
    OfferCurrencyIsNotListingCurrency,
    OfferNotExists
} from "../../../interfaces/ITruhuisMarketplace.sol";

/**
 * @title AbstractNegotiationStage
 * @author _
 * @dev _
 */
abstract contract AbstractNegotiationStage is TruhuisAddressRegistryAdapter {
    /**
     * @dev _
     */
    event AcceptedOfferCancelled__NegotiationStage(
        address indexed offerer,
        uint256 indexed offerId,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     */
    event ListingCancelled__NegotiationStage(
        address indexed seller,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     */
    event OfferCreated__NegotiationStage(
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
    event OfferCancelled__NegotiationStage(
        address indexed offerer,
        uint256 offerId,
        uint256 indexed tokenId
    );

    /**
     * @dev _
     */
    function _cancelAcceptedOffer__NegotiationStage(Listing storage _sListing)
        internal
        virtual;

    /**
     * @dev No purchase agreement
     */
    function _cancelListing__NegotiationStage(
        uint256 _tokenId,
        Listing storage _sListing
    ) internal virtual;

    /**
     * @dev _
     */
    function _cancelOffer__NegotiationStage(
        uint256 _offerId,
        Listing storage _sListing
    ) internal virtual;

    /**
     * @dev _
     */
    function _createOffer__NegotiationStage(
        address _currency,
        uint256 _expiry,
        uint256 _price,
        uint256 _tokenId,
        Listing storage _sListing
    ) internal virtual;

    ///**
    // * @dev _
    // */
    //function _createPurchaseAgreement() internal virtual;
}
