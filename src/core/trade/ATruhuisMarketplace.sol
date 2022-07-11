// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@core/addresser/TruhuisAddresserAPI.sol";
import "@interfaces/ITruhuisMarketplace.sol";

import "@libraries/IdentificationLogic.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title ATruhuisMarketplace
 * @author vsevdrob
 * @notice _
 */
abstract contract ATruhuisMarketplace is
    Ownable,
    TruhuisAddresserAPI,
    ITruhuisMarketplace,
    ReentrancyGuard,
    IdentificationLogic
{
    /* PRIVATE STORAGE */

    /// @dev Token ID => Listing struct.
    mapping(uint256 => Listing) private _sListings;
    /// @dev Token ID => Offer ID => Offer struct.
    mapping(uint256 => mapping(uint256 => Offer)) private _sOffers;
    /// @dev Token ID => Offer IDs counter.
    mapping(uint256 => uint256) private _sOfferIds;

    /// @dev Truhuis Marketplace service fee (e.g. 100 (1%); 1000 (10%)).
    uint96 private _sServiceFee;

    /* INTERNAL FUNCTIONS */

    /**
     * @dev _
     * NOTE: Available stage.
     */
    function _acceptOffer(
        address _offerer,
        uint256 _offerId,
        uint256 _tokenId
    ) internal virtual {
        /* ARRANGE */

        // Get listing.
        Listing storage sListing = _sListings[_tokenId];

        // Get offer.
        Offer storage sOffer = _sOffers[_tokenId][_offerId];

        // Get offer accepted time.
        uint256 timeAccepted = block.timestamp;

        /* PERFORM ASSERTIONS */

        // Offer must be existent.
        if (!sOffer.exists) {
            revert OFFER_NOT_EXISTS(msg.sender, _offerId, _tokenId);
        }

        // Offer must be not already accepted.
        if (sListing.acceptedOffer.offerId == _offerId) {
            revert OFFER_ACCEPTED(_offerer, _offerId, _tokenId);
        }

        // An offer must be not already accepted.
        if (sListing.acceptedOffer.exists) {
            revert ACCEPTED_OFFER_EXISTS();
        }

        // Offer must be not expired.
        if (block.timestamp > sOffer.expiry) {
            revert OFFER_EXPIRED(_offerer, _offerId, _tokenId);
        }

        // Listing must be at available stage.
        if (sListing.stage != Stage.AVAILABLE) {
            revert INVALID_STAGE(Stage.AVAILABLE, sListing.stage);
        }

        // Auction must be not in action. Uncomment if Truhuis Auction created.
        //if (trade().getAuctionStartTime(_tokenId) > 0) {
        //    revert AUCTION_IN_ACTION(_tokenId);
        //}

        /* ACCEPT OFFER */

        // address
        sListing.acceptedOffer.currency = sOffer.currency;
        sListing.acceptedOffer.offerer = _offerer;

        // bool
        sListing.acceptedOffer.exists = true;

        // enum
        sListing.stage = Stage.NEGOTIATION;

        // uint256
        sListing.acceptedOffer.offerId = _offerId;
        sListing.acceptedOffer.price = sOffer.price;
        sListing.acceptedOffer.timeAccepted = timeAccepted;

        // Emit an {OfferAccepted} event.
        emit OfferAccepted(_offerer, _offerId, timeAccepted, _tokenId);
    }

    /**
     * @dev _
     * NOTE: Negotiation stage.
     */
    function _cancelAcceptedOffer(uint256 _tokenId) internal virtual {
        /* ARRANGE */

        // Get listing.
        Listing storage sListing = _sListings[_tokenId];

        // Get offerer.
        address offerer = sListing.acceptedOffer.offerer;

        // Get accepted offer ID.
        uint256 offerId = sListing.acceptedOffer.offerId;

        /* PERFORM ASSERTIONS */

        // Accepted offer must be existent.
        if (!sListing.acceptedOffer.exists) {
            revert ACCEPTED_OFFER_NOT_EXISTS();
        }

        // Listing must be at negotiation stage.
        if (sListing.stage != Stage.NEGOTIATION) {
            revert INVALID_STAGE(Stage.NEGOTIATION, sListing.stage);
        }

        /* CANCEL ACCEPTED OFFER */

        delete sListing.acceptedOffer;

        // Emit an {AcceptedOfferCancelled} event.
        emit AcceptedOfferCancelled(offerer, offerId, _tokenId);
    }

    /**
     * @dev _
     * NOTE: Available stage & negotiation stage.
     */
    function _cancelListing(uint256 _tokenId) internal virtual {
        /* ARRANGE */

        // Get listing.
        Listing storage sListing = _sListings[_tokenId];

        /* PERFORM ASSERTIONS */

        // Listing must be existent.
        if (!sListing.exists) {
            revert LISTING_NOT_EXISTS(_tokenId);
        }

        // Listing must be at available or negotiation stage.
        if (
            sListing.stage != Stage.AVAILABLE ||
            sListing.stage != Stage.NEGOTIATION
        ) {
            revert STAGE_SOLD();
        }

        /* CANCEL LISTING */

        // address
        delete sListing.currency;
        delete sListing.seller;

        // bool
        delete sListing.exists;

        // struct
        delete sListing.acceptedOffer;
        delete sListing.stage;

        // uint256
        delete sListing.endTime;
        delete sListing.initialPrice;
        delete sListing.startTime;
        delete sListing.tokenId;

        // Emit a {ListingCancelled} event.
        emit ListingCancelled(msg.sender, _tokenId);
    }

    /**
     * @dev _
     * NOTE: Available stage & negotiation stage.
     */
    function _cancelOffer(uint256 _offerId, uint256 _tokenId) internal virtual {
        /* ARRANGE */

        // Get listing.
        Listing memory listing = _sListings[_tokenId];

        // Get existent offer.
        Offer memory offer = _sOffers[_tokenId][_offerId];

        /* PERFORM ASSERTIONS */

        // Offer must be existent.
        if (!offer.exists) {
            revert OFFER_NOT_EXISTS(msg.sender, _offerId, _tokenId);
        }

        // Listing must be at available or negotiation stage.
        if (
            listing.stage != Stage.AVAILABLE ||
            listing.stage != Stage.NEGOTIATION
        ) {
            revert STAGE_SOLD();
        }

        // Caller must be the offerer.
        if (offer.offerer != msg.sender) {
            revert CALLER_NOT_OFFERER(msg.sender, offer.offerer);
        }

        /* CANCEL OFFER */

        delete _sOffers[_tokenId][_offerId];

        // Emit an {OfferCancelled} event.
        emit OfferCancelled(msg.sender, _offerId, _tokenId);
    }

    /**
     * @dev _
     * NOTE: Available stage & negotiation stage.
     */
    function _createOffer(
        address _currency,
        uint256 _expiry,
        uint256 _price,
        uint256 _tokenId
    ) internal virtual {
        /* ARRANGE */

        // Get listing.
        Listing memory listing = _sListings[_tokenId];

        // Get current time.
        uint256 currentTime = block.timestamp;

        // Get free offer ID.
        uint256 offerId = _sOfferIds[_tokenId] + 1;

        // Get offer initialized offer.
        Offer storage sOffer = _sOffers[_tokenId][offerId];

        /* PERFORM ASSERTIONS */

        // Listing must be at available or negotiation stage.
        if (
            listing.stage != Stage.AVAILABLE &&
            listing.stage != Stage.NEGOTIATION
        ) {
            revert STAGE_SOLD();
        }

        // Auction must be not in action. Uncomment if there is Truhuis Auction.
        //if (trade().getAuctionStartTime(_tokenId) > 0) {
        //    revert AUCTION_IN_ACTION(_tokenId);
        //}

        // Expiry must be greater than current time.
        if (currentTime > _expiry) {
            revert EXPIRY_NOT_HIGHER_THAN_NOW(currentTime, _expiry);
        }

        // Offer currency must be equal to listing currency.
        if (_currency != listing.currency) {
            revert INVALID_OFFER_CURRENCY(_currency, listing.currency);
        }

        /* CREATE OFFER */

        // address
        sOffer.currency = _currency;
        sOffer.offerer = msg.sender;

        // bool
        sOffer.exists = true;

        // uint256
        sOffer.expiry = _expiry;
        sOffer.price = _price;

        /* INCREMENT FREE OFFER ID */

        _sOfferIds[_tokenId]++;

        // Emit an {OfferCreated} event.
        emit OfferCreated(
            _currency,
            msg.sender,
            _expiry,
            offerId,
            _price,
            _tokenId
        );
    }

    /**
     * @dev _
     * NOTE: Available stage.
     */
    function _list(
        address _currency,
        uint256 _price,
        uint256 _tokenId
    ) internal virtual {
        /* ARRANGE */

        // Get listing.
        Listing storage sListing = _sListings[_tokenId];

        /* PERFORM ASSERTIONS */

        // Listing must be at `NONE` stage.
        if (sListing.stage != Stage.NONE) {
            revert INVALID_STAGE(Stage.NONE, sListing.stage);
        }

        // Listing must be non-existent.
        if (sListing.exists) {
            revert LISTING_ALREADY_EXISTS(_tokenId);
        }

        // Caller cannot be a smart contract.
        if (msg.sender.code.length > 0) {
            revert CALLER_NOT_HUMAN(msg.sender);
        }

        // Initial price must be greater than zero.
        if (0 >= _price) {
            revert PRICE_NOT_GREATER_THAN_ZERO();
        }

        // Currency must be allowed.
        if (!bank().isAllowedCurrency(_currency)) {
            revert INVALID_CURRENCY(_currency);
        }

        /* LIST REAL ESTATE */

        // address
        sListing.currency = _currency;
        sListing.seller = msg.sender;

        // bool
        sListing.exists = true;

        // struct
        sListing.stage = Stage.AVAILABLE;

        // uint256
        sListing.endTime = 0;
        sListing.initialPrice = _price;
        sListing.startTime = block.timestamp;
        sListing.tokenId = _tokenId;

        // Emit a {Listed} event.
        emit Listed(
            _currency,
            msg.sender,
            _price,
            sListing.startTime,
            _tokenId
        );
    }

    /**
     * @dev _
     * NOTE: Negotiation stage.
     */
    function _setListingSold(uint256 _tokenId) internal virtual {
        /* ARRANGE */

        // Get listing.
        Listing storage sListing = _sListings[_tokenId];

        /* PERFORM ASSERTIONS */

        // Caller must be the notary.
        if (msg.sender != address(notary())) {
            revert CALLER_NOT_NOTARY();
        }

        // Listing must be at `NEGOTIATION` stage.
        if (sListing.stage != Stage.NEGOTIATION) {
            revert INVALID_STAGE(Stage.NEGOTIATION, sListing.stage);
        }

        /* SET LISTING SOLD */

        sListing.stage = Stage.SOLD;

        // Emit a {Sold} event.
        emit Sold(_tokenId);
    }

    /**
     * @dev _
     * NOTE: Available stage.
     */
    function _updateListingCurrency(address _newCurrency, uint256 _tokenId)
        internal
        virtual
    {
        /* ARRANGE */

        // Get listing.
        Listing storage sListing = _sListings[_tokenId];

        /* PERFORM ASSERTIONS */

        // Listing must be existent.
        if (!sListing.exists) {
            revert LISTING_NOT_EXISTS(_tokenId);
        }

        // Listing must be at available or negotiation stage.
        if (
            sListing.stage != Stage.AVAILABLE ||
            sListing.stage != Stage.NEGOTIATION
        ) {
            revert STAGE_SOLD();
        }

        // Currency must be allowd.
        if (!bank().isAllowedCurrency(_newCurrency))
            revert INVALID_CURRENCY(_newCurrency);

        /* UPDATE LISTING CURRENCY */

        sListing.currency = _newCurrency;

        // Emit a {Listed} event.
        emit Listed(
            _newCurrency,
            msg.sender,
            sListing.initialPrice,
            sListing.startTime,
            _tokenId
        );
    }

    /**
     * @dev _
     * NOTE: Available stage.
     */
    function _updateListingPrice(uint256 _newPrice, uint256 _tokenId)
        internal
        virtual
    {
        /* ARRANGE */

        // Get listing.
        Listing storage sListing = _sListings[_tokenId];

        /* PERFORM ASSERTIONS */

        // Listing must be existent.
        if (!sListing.exists) {
            revert LISTING_NOT_EXISTS(_tokenId);
        }

        // Listing must be at available or negotiation stage.
        if (
            sListing.stage != Stage.AVAILABLE ||
            sListing.stage != Stage.NEGOTIATION
        ) {
            revert STAGE_SOLD();
        }

        // Price must be greater than zero.
        if (0 >= _newPrice) {
            revert PRICE_NOT_GREATER_THAN_ZERO();
        }

        /* UPDATE LISTING PRICE */

        sListing.initialPrice = _newPrice;

        // Emit a {Listed} event.
        emit Listed(
            sListing.currency,
            msg.sender,
            _newPrice,
            sListing.startTime,
            _tokenId
        );
    }

    /**
     * @dev _
     */
    function _updateServiceFee(uint96 _newServiceFee) internal virtual {
        /* ARRANGE */

        // Get old service fee.
        uint96 oldServiceFee = _sServiceFee;

        /* PERFORM ASSERTIONS */

        // `_newServiceFee` must be not identical to `oldServiceFee`.
        if (_newServiceFee == oldServiceFee) {
            revert IDENTICAL_SERVICE_FEE_PROVIDED();
        }

        /* UPDATE SERVICE FEE */

        _sServiceFee = _newServiceFee;

        // Emit a {ServiceFeeUpdated} event.
        emit ServiceFeeUpdated(_newServiceFee, oldServiceFee);
    }

    /* INTERNAL VIEW FUNCTIONS */

    /**
     * @dev _
     */
    function _getListing(uint256 _tokenId)
        internal
        view
        returns (Listing memory)
    {
        return _sListings[_tokenId];
    }
}
