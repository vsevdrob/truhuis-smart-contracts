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
abstract contract AvailableStage is AbstractAvailableStage {

    ///@inheritdoc AbstractAvailableStage


    /// @inheritdoc AbstractAvailableStage
    function _cancelListing__AvailableStage(
        uint256 _tokenId,
        Listing storage _sListing
    ) 
        internal
        override
    {

        /* PERFORM ASSERTIONS */

        // Listing must be existent.
        if (!_sListing.exists) {
            revert ListingNotExists(_tokenId);
        }

        /* CANCEL LISTING */

        //delete _sListing;

        // Emit a {ListingCancelled__AvailableStage} event.
        emit ListingCancelled__AvailableStage(
            msg.sender,
            _tokenId
        );
    }

    /// @inheritdoc AbstractAvailableStage
    function _cancelOffer__AvailableStage(
        uint256 _tokenId,
        Offer storage _sOffer
    )
        internal
        override
    {

        /* PERFORM ASSERTIONS */

        // Offer must be existent.
        if (!_sOffer.exists) {
            revert OfferNotExists(msg.sender, _tokenId);
        }

        // Caller must be the offerer.
        if (_sOffer.offerer != msg.sender) {
            revert MsgSenderIsNotOfferer(msg.sender, _sOffer.offerer);
        }

        /* CANCEL OFFER */

        //delete _sOffer;

        // Emit an {OfferCancelled__AvailableStage} event.
        emit OfferCancelled__AvailableStage(msg.sender, _tokenId);
    }

    /// @inheritdoc AbstractAvailableStage
    function _createOffer__AvailableStage(
        address _currency,
        address _listingCurrency,
        uint256 _expiry,
        uint256 _highestPriceOffer,
        uint256 _priceOffer,
        uint256 _tokenId,
        Listing storage _sListing,
        Offer storage _sOffer
    ) internal override {

        /* PERFORM ASSERTIONS */

        // Offer must be non-existent.
        if (_sOffer.exists) {
            revert OfferAlreadyExists(msg.sender, _tokenId);
        }

        // Auction must be not in action.
        if (auction().getStartTime(_tokenId) > 0) {
            revert AuctionIsInAction(_tokenId);
        }

        // Expiry must be greater than current time.
        if (block.timestamp > _expiry) {
            revert ExpiryMustBeHigherThanNow(block.timestamp, _expiry);
        }

        // Offer currency must be equal to listing currency.
        if (_currency != _listingCurrency) {
            revert OfferCurrencyIsNotListingCurrency(_currency, _listingCurrency);
        }

        // Made price offer must be greater than current highest price offer.
        if (_highestPriceOffer >= _priceOffer) {
            revert NotHighestPriceOffer(_highestPriceOffer, _priceOffer);
        }

        /* UPDATE HIGHEST PRICE OFFER */

        _sListing.highestPriceOffer = _priceOffer;

        /* CREATE OFFER */

        // address
        _sOffer.currency =_currency;
        _sOffer.offerer = msg.sender;

        // bool
        _sOffer.exists = true;

        // uint256
        _sOffer.expiry = _expiry;
        _sOffer.price = _priceOffer;
        _sOffer.tokenId = _tokenId;

        // Emit an {OfferCreated__AvailableStage} event.
        emit OfferCreated__AvailableStage(
            _currency,
            msg.sender,
            _expiry,
            _priceOffer,
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
        _sListing.highestPriceOffer = 0;
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
