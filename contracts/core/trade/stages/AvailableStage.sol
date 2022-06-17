// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./AbstractAvailableStage.sol";

/**
 * @title AvailableStage
 * @author _
 * @notice 1. List real estate NFT
 *         2. Update listing currency
 *         3. Update listing price
 *         4. Cancel listing
 *         5. Create offer (also while negotiation)
 *         6. Cancel offer (also while negotiation)
 */
contract AvailableStage is AbstractAvailableStage {
    ///@inheritdoc AbstractAvailableStage
    function _acceptOffer__AvailableStage(
        address _offerer,
        uint256 _offerId,
        Listing storage _sListing
    ) internal override {
        /* ARRANGE */

        // Get token ID.
        uint256 tokenId = _sListing.tokenId;

        // Get offer accepted time.
        uint256 timeAccepted = block.timestamp;

        // Get offer.
        Offer storage sOffer = _sListing.madeOffers[_offerer][_offerId];

        /* PERFORM ASSERTIONS */

        // Auction must be not in action.
        if (auction().getStartTime(tokenId) > 0) {
            revert AuctionIsInAction(tokenId);
        }

        // Offer must be existent.
        if (!sOffer.exists) {
            revert OfferNotExists(msg.sender, _offerId, tokenId);
        }

        /* ACCEPT OFFER */

        // address
        _sListing.acceptedOffer.currency = sOffer.currency;
        _sListing.acceptedOffer.offerer = _offerer;

        // bool
        _sListing.acceptedOffer.exists = true;

        // enum
        _sListing.stage = Stage.negotiation;

        // uint256
        _sListing.acceptedOffer.offerId = _offerId;
        _sListing.acceptedOffer.price = sOffer.price;
        _sListing.acceptedOffer.timeAccepted = timeAccepted;

        // Emit an {OfferAccepted__AvailableStage} event.
        emit OfferAccepted__AvailableStage(
            _offerer,
            _offerId,
            timeAccepted,
            tokenId
        );
    }

    /// @inheritdoc AbstractAvailableStage
    function _cancelListing__AvailableStage(
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

        // Emit a {ListingCancelled__AvailableStage} event.
        emit ListingCancelled__AvailableStage(msg.sender, _tokenId);
    }

    /// @inheritdoc AbstractAvailableStage
    function _cancelOffer__AvailableStage(
        uint256 _offerId,
        Listing storage _sListing
    ) internal override {
        /* ARRANGE */

        // Get listing token ID.
        uint256 tokenId = _sListing.tokenId;

        // Get existent offer.
        Offer memory offer = _sListing.madeOffers[msg.sender][_offerId];

        /* PERFORM ASSERTIONS */

        // Offer must be existent.
        if (!offer.exists) {
            revert OfferNotExists(msg.sender, _offerId, tokenId);
        }

        // Caller must be the offerer.
        if (offer.offerer != msg.sender) {
            revert MsgSenderIsNotOfferer(msg.sender, offer.offerer);
        }

        /* CANCEL OFFER */

        delete _sListing.madeOffers[msg.sender][_offerId];

        // Emit an {OfferCancelled__AvailableStage} event.
        emit OfferCancelled__AvailableStage(msg.sender, _offerId, tokenId);
    }

    /// @inheritdoc AbstractAvailableStage
    function _createOffer__AvailableStage(
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

        // Emit an {OfferCreated__AvailableStage} event.
        emit OfferCreated__AvailableStage(
            _currency,
            msg.sender,
            _expiry,
            offerId,
            _price,
            _tokenId
        );
    }

    /// @inheritdoc AbstractAvailableStage
    function _listRealEstate__AvailableStage(
        address _currency,
        uint256 _tokenId,
        uint256 _price,
        Listing storage _sListing
    ) internal override {
        /* PERFORM ASSERTIONS */

        // Listing must be non-existent.
        if (_sListing.exists) {
            revert ListingAlreadyExists(_tokenId);
        }

        // Caller cannot be a smart contract.
        if (msg.sender.code.length > 0) {
            revert AccountMustBeHuman(msg.sender);
        }

        // Initial price must be greater than zero.
        if (0 >= _price) {
            revert PriceMustBeGreaterThanZero();
        }

        // Currency must be allowed.
        if (!currencyRegistry().isAllowed(_currency)) {
            revert InvalidCurrency(_currency);
        }

        /* LIST REAL ESTATE */

        // address
        _sListing.buyer = address(0);
        _sListing.currency = _currency;
        _sListing.purchaseAgreement = address(0);
        _sListing.seller = msg.sender;

        // bool
        _sListing.exists = true;

        // struct
        _sListing.stage = Stage.available;

        // uint256
        _sListing.endTime = 0;
        _sListing.initialPrice = _price;
        _sListing.startTime = block.timestamp;
        _sListing.tokenId = _tokenId;

        // Emit a {RealEstateListed__AvailableStage} event.
        emit RealEstateListed__AvailableStage(
            _currency,
            msg.sender,
            _price,
            _sListing.startTime,
            _tokenId
        );
    }

    /// @inheritdoc AbstractAvailableStage
    function _updateListingCurrency__AvailableStage(
        address _newCurrency,
        uint256 _tokenId,
        Listing storage _sListing
    ) internal override {
        /* PERFORM ASSERTIONS */

        // Listing must be existent.
        if (!_sListing.exists) {
            revert ListingNotExists(_tokenId);
        }

        // Currency must be allowed.
        if (!currencyRegistry().isAllowed(_newCurrency))
            revert InvalidCurrency(_newCurrency);

        /* UPDATE LISTING CURRENCY */

        _sListing.currency = _newCurrency;

        // Emit a {RealEstateListed__AvailableStage} event.
        emit RealEstateListed__AvailableStage(
            _newCurrency,
            msg.sender,
            _sListing.initialPrice,
            _sListing.startTime,
            _tokenId
        );
    }

    /// @inheritdoc AbstractAvailableStage
    function _updateListingPrice__AvailableStage(
        uint256 _tokenId,
        uint256 _newPrice,
        Listing storage _sListing
    ) internal override {
        /* PERFORM ASSERTIONS */

        // Listing must be existent.
        if (!_sListing.exists) {
            revert ListingNotExists(_tokenId);
        }

        // Price must be greater than zero.
        if (0 >= _newPrice) {
            revert PriceMustBeGreaterThanZero();
        }

        /* UPDATE LISTING PRICE */

        _sListing.initialPrice = _newPrice;

        // Emit a {RealEstateListed__AvailableStage} event.
        emit RealEstateListed__AvailableStage(
            _sListing.currency,
            msg.sender,
            _newPrice,
            _sListing.startTime,
            _tokenId
        );
    }
}
