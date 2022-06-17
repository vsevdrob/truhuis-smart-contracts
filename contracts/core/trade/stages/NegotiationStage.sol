// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./AbstractNegotiationStage.sol";

contract NegotiationStage is AbstractNegotiationStage {
    /// @inheritdoc AbstractNegotiationStage
    function _cancelAcceptedOffer__NegotiationStage(Listing storage _sListing)
        internal
        override
    {
        /* ARRANGE */

        // Get offerer.
        address offerer = _sListing.acceptedOffer.offerer;

        // Get accepted offer ID.
        uint256 offerId = _sListing.acceptedOffer.offerId;

        // Get token ID.
        uint256 tokenId = _sListing.tokenId;

        /* PERFORM ASSERTIONS */

        // Accepted offer must be existent.
        if (!_sListing.acceptedOffer.exists) {
            revert AcceptedOfferNotExists();
        }

        /* CANCEL ACCEPTED OFFER */

        delete _sListing.acceptedOffer;

        // Emit an {AcceptedOfferCancelled__NegotiationStage} event.
        emit AcceptedOfferCancelled__NegotiationStage(
            offerer,
            offerId,
            tokenId
        );
    }

    /// @inheritdoc AbstractNegotiationStage
    function _cancelListing__NegotiationStage(
        uint256 _tokenId,
        Listing storage _sListing
    ) internal override {
        /* PERFORM ASSERTIONS */

        // Listing must be existent.
        if (!_sListing.exists) {
            revert ListingNotExists(_tokenId);
        }

        /* CANCEL LISTING */

        // address
        delete _sListing.buyer;
        delete _sListing.currency;
        delete _sListing.purchaseAgreement;
        delete _sListing.seller;

        // bool
        delete _sListing.exists;

        //// mapping
        //delete _sListing.offer;

        // struct
        delete _sListing.acceptedOffer;
        delete _sListing.stage;

        // uint256
        delete _sListing.endTime;
        delete _sListing.freeOfferId;
        delete _sListing.initialPrice;
        delete _sListing.startTime;
        delete _sListing.tokenId;

        // Emit a {ListingCancelled__NegotiationStage} event.
        emit ListingCancelled__NegotiationStage(msg.sender, _tokenId);
    }

    ///@inheritdoc AbstractNegotiationStage
    function _cancelOffer__NegotiationStage(
        uint256 _offerId,
        Listing storage _sListing
    ) internal override {
        /* ARRANGE */

        // Get token ID.
        uint256 tokenId = _sListing.tokenId;

        // Get existent offer.
        Offer memory offer = _sListing.madeOffers[msg.sender][_offerId];

        /* PERFORM ASSERTIONS */

        // Offer must be existent.
        if (offer.exists) {
            revert OfferNotExists(msg.sender, _offerId, tokenId);
        }

        // Caller must be the offerer.
        if (offer.offerer != msg.sender) {
            revert MsgSenderIsNotOfferer(msg.sender, offer.offerer);
        }

        /* CANCEL OFFER */

        delete _sListing.madeOffers[msg.sender][_offerId];

        // Emit an {OfferCancelled__NegotiationStage} event.
        emit OfferCancelled__NegotiationStage(msg.sender, _offerId, tokenId);
    }

    /// @inheritdoc AbstractNegotiationStage
    function _createOffer__NegotiationStage(
        address _currency,
        uint256 _expiry,
        uint256 _price,
        uint256 _tokenId,
        Listing storage _sListing
    ) internal override {
        /* ARRANGE */

        // Get current time.
        uint256 currentTime = block.timestamp;

        // Get free offer ID.
        uint256 offerId = _sListing.freeOfferId;

        // Get initialized offer.
        Offer storage sOffer = _sListing.madeOffers[msg.sender][offerId];

        // Get listing currency.
        address listingCurrency = _sListing.currency;

        /* PERFORM ASSERTIONS */

        // Auction must be not in action.
        if (auction().getStartTime(_tokenId) > 0) {
            revert AuctionIsInAction(_tokenId);
        }

        // Expiry must be greater than current time.
        if (currentTime > _expiry) {
            revert ExpiryMustBeHigherThanNow(currentTime, _expiry);
        }

        // Offer currency must be equal to listing currency.
        if (_currency != listingCurrency) {
            revert OfferCurrencyIsNotListingCurrency(
                _currency,
                listingCurrency
            );
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

        _sListing.freeOfferId++;

        // Emit an {OfferCreated__NegotiationStage} event.
        emit OfferCreated__NegotiationStage(
            _currency,
            msg.sender,
            _expiry,
            offerId,
            _price,
            _tokenId
        );
    }
}
