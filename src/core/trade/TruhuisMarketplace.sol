// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./ATruhuisMarketplace.sol";

/**
 * @title TruhuisMarketplace
 * @author vsevdrob
 * @notice _
 */
contract TruhuisMarketplace is ATruhuisMarketplace {
    constructor(address _addressRegistry, uint96 _serviceFee) {
        updateAddressRegistry(_addressRegistry);
        _updateServiceFee(_serviceFee);
    }

    /// @inheritdoc ITruhuisMarketplace
    function acceptOffer(
        address _offerer,
        uint256 _offerId,
        uint256 _tokenId
    ) external override onlySeller(msg.sender, _tokenId) {
        _acceptOffer(_offerer, _offerId, _tokenId);
    }

    /// @inheritdoc ITruhuisMarketplace
    function cancelAcceptedOffer(uint256 _tokenId)
        external
        override
        onlySeller(msg.sender, _tokenId)
    {
        _cancelAcceptedOffer(_tokenId);
    }

    /// @inheritdoc ITruhuisMarketplace
    function cancelListing(uint256 _tokenId)
        external
        override
        onlySeller(msg.sender, _tokenId)
    {
        _cancelListing(_tokenId);
    }

    /// @inheritdoc ITruhuisMarketplace
    function cancelOffer(uint256 _offerId, uint256 _tokenId)
        external
        override
        onlyBuyer(msg.sender, _tokenId)
    {
        _cancelOffer(_offerId, _tokenId);
    }

    /// @inheritdoc ITruhuisMarketplace
    function createOffer(
        address _currency,
        uint256 _expiry,
        uint256 _price,
        uint256 _tokenId
    ) external override onlyBuyer(msg.sender, _tokenId) {
        _createOffer(_currency, _expiry, _price, _tokenId);
    }

    /// @inheritdoc ITruhuisMarketplace
    function list(
        address _currency,
        uint256 _price,
        uint256 _tokenId
    ) external override onlySeller(msg.sender, _tokenId) {
        _list(_currency, _price, _tokenId);
    }

    /// @inheritdoc ITruhuisMarketplace
    function setListingSold(uint256 _tokenId)
        external
        override
    {
        _setListingSold(_tokenId);
    }

    /// @inheritdoc ITruhuisMarketplace
    function updateListingCurrency(address _newCurrency, uint256 _tokenId)
        external
        override
        onlySeller(msg.sender, _tokenId)
    {
        _updateListingCurrency(_newCurrency, _tokenId);
    }

    /// @inheritdoc ITruhuisMarketplace
    function updateListingPrice(uint256 _newPrice, uint256 _tokenId)
        external
        override
        onlySeller(msg.sender, _tokenId)
    {
        _updateListingPrice(_newPrice, _tokenId);
    }

    /// @inheritdoc ITruhuisMarketplace
    function updateServiceFee(uint96 _newServiceFee)
        external
        override
        onlyOwner
    {
        _updateServiceFee(_newServiceFee);
    }

    /// @inheritdoc ITruhuisMarketplace
    function getListing(uint256 _tokenId)
        external
        view
        override
        returns (Listing memory)
    {
        return _getListing(_tokenId);
    }

    ///// @inheritdoc ITruhuisMarketplace
    //function updateMarketplaceOwner(address _newOwner) external onlyOwner {
    //    if (_newOwner == _sMarketplaceOwner) {
    //        revert MarketplaceOwnerUpdateFailed();
    //    }

    //    _sMarketplaceOwner = _newOwner;
    //    emit MarketplaceOwnerUpdated(_newOwner);
    //}

    //function _sGetOffer(address _offerer, uint256 _tokenId)
    //    private
    //    view
    //    returns (Offer storage)
    //{
    //    if (!_sListings[_tokenId].exists) {
    //        revert ListingNotExists(_tokenId);
    //    }

    //    return _sListings[_tokenId].offer[_offerer];
    //}

    //function cancelPurchase(uint256 _tokenId)
    //    external
    //    nonReentrant
    //    onlyBuyer(msg.sender, _tokenId)
    //{
    //    // Validate contract logic.
    //
    //    Listing storage s_listing = s_listings[_tokenId];

    //    // Validate listing should be existent.
    //    _validateIsExistentListing(_tokenId);
    //    // Validate whether a caller is the buyer.
    //    _validateMsgSender(msg.sender, s_listing.buyer);
    //    // Validate whether Real Estate was purchased.
    //    _validateListingStage(s_listing.stage, Stage.coolingOffPeriod);

    //    // Cancel purchase.

    //    uint256 purchasePrice = s_listing.purchasePrice;

    //    delete s_listing.buyer;
    //    delete s_listing.purchasePrice;
    //    delete s_listing.purchaseTime;

    //    s_listing.stage = Stage.available;

    //    // Send funds back to the buyer.
    //    if (!IERC20(s_listing.currency).transfer(msg.sender, purchasePrice)) {
    //        revert UnableToCancelPurchase(_tokenId);
    //    }

    //    // Emit Purchase Canceled event.
    //    emit PurchaseCanceled(
    //        msg.sender,
    //        _tokenId,
    //        Stage.available
    //    );
    //}

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // UPDATE ONLY OWNER
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // EXTERNAL
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    //function withdrawTransferTaxes(address _currency) external nonReentrant {
    //    uint256 transferTaxes = s_transferTaxes[msg.sender][_currency];

    //    require(transferTaxes > 0, "no transfer taxes");

    //    s_transferTaxes[msg.sender][_currency] = 0;

    //    require(IERC20(_currency).transfer(msg.sender, transferTaxes), "failed to withdraw transfer taxes");

    //    emit TransferTaxesWithdrew(msg.sender, _currency, transferTaxes);
    //}

    //function withdrawSellerProceeds(address _currency) external nonReentrant {
    //    uint256 proceeds = s_sellerProceeds[msg.sender][_currency];
    //
    //    require(proceeds > 0, "no proceeds");

    //    s_sellerProceeds[msg.sender][_currency] = 0;
    //
    //    require(IERC20(_currency).transfer(msg.sender, proceeds), "failed to withdraw proceeds");

    //    emit SellerProceedsWithdrew(msg.sender, _currency, proceeds);
    //}

    //function withdrawMarketplaceProceeds(address _currency) external nonReentrant {
    //    require(msg.sender == marketplaceOwner, "not marketplace owner");

    //    uint256 marketplaceProceeds = s_marketplaceProceeds[_currency];

    //    require(marketplaceProceeds > 0, "no marketplace proceeds");

    //    s_marketplaceProceeds[_currency] = 0;

    //    require(
    //        IERC20(_currency).transfer(marketplaceOwner, marketplaceProceeds),
    //        "failed to withdraw marketplace proceeds"
    //    );

    //    emit MarketplaceProceedsWithdrew(_currency, marketplaceProceeds);
    //}

    //function purchaseRealEstate(uint256 _tokenId)
    //    external
    //    nonReentrant
    //    onlyBuyer(msg.sender, _tokenId)
    //{
    //    // Validate contract logic.

    //    // Validate listing should be existent.
    //    _validateIsExistentListing(_tokenId);

    //    Listing storage s_listing = s_listings[_tokenId];
    //
    //    // Validate buyer has sufficient funds to purchase the property.
    //    _validateHasSufficientFunds(msg.sender, s_listing.currency, s_listing.initialPrice);

    //    // Purchase Real Estate.

    //    s_listing.buyer = msg.sender;
    //    s_listing.purchasePrice = s_listing.initialPrice;
    //    s_listing.purchaseTime = block.timestamp;

    //    _purchaseRealEstate(msg.sender, _tokenId, s_listing.initialPrice);

    //    // Emit Real Estate Purchased event.
    //    emit RealEstatePurchased(
    //        msg.sender,
    //        s_listing.seller,
    //        _tokenId,
    //        s_listing.purchaseTime,
    //        s_listing.purchasePrice,
    //        s_listing.stage
    //    );
    //}

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // PUBLIC
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    //function verifySeller(address _seller, uint256 _tokenId) public {
    //    if (!s_isVerifiedSeller[_tokenId][_seller]) {
    //        _validateSeller(_seller, _tokenId);
    //        require(isMarketplaceApproved(_tokenId), "marketplace must be approved");
    //        //require(isAuctionApproved(_tokenId), "auction must be approved");
    //        s_isVerifiedSeller[_tokenId][_seller] = true;
    //    }
    //}

    //          xxxxxxxxxxx                xxxxxxxxxxxxx
    // PUBLIC VIEW RETURNS
    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    //function getBuyer(uint256 _tokenId) public view returns (address) {
    //    _validateIsExistentListing(_tokenId);
    //    return s_listings[_tokenId].buyer;
    //}

    //function getCoolingOffPeriod(uint256 _tokenId) public view returns (uint256) {
    //    (address transferTaxReceiver,) = cadastre().royaltyInfo(_tokenId, uint256(1));
    //    uint256 coolingOffPeriod = stateGovernment(transferTaxReceiver).getCoolingOffPeriod();
    //    return coolingOffPeriod;
    //}

    //function getInitialTime(uint256 _tokenId) public view returns (uint256) {
    //    _validateIsExistentListing(_tokenId);
    //    return s_listings[_tokenId].initialTime;
    //}

    //function getListing(uint256 _tokenId) public view returns (Listing memory) {
    //    _validateIsExistentListing(_tokenId);
    //    return s_listings[_tokenId];
    //}

    //function getMarketplaceCommission(uint256 _salePrice) public view returns (uint256) {
    //    // price = 250000 USDT * (10**18)
    //    // price * 250 / 10000 = 6250 USDT * (10**18)
    //    return _salePrice * marketplaceCommissionFraction / 10000;
    //}

    //function getRealEstateCountry(uint256 _tokenId) public view returns (bytes3) {
    //    (address transferTaxReceiver,) = cadastre().royaltyInfo(_tokenId, uint256(1));
    //    bytes3 country = stateGovernment(transferTaxReceiver).getStateGovernmentCountry();
    //    return country;
    //}

    //function getTransferTaxes(address _transferTaxReceiver, address _currency) external view returns (uint256) {
    //    return s_transferTaxes[_transferTaxReceiver][_currency];
    //}

    //function getSellerProceeds(address _seller, address _currency) external view returns (uint256) {
    //    return s_sellerProceeds[_seller][_currency];
    //}

    //function getMarketplaceProceeds(address _currency) public view returns (uint256) {
    //    return s_marketplaceProceeds[_currency];
    //}

    //function getTransferTaxInfo(address _buyer, uint256 _tokenId, uint256 _salePrice) public view returns (address, uint256) {
    //    _identifyBuyer(_buyer, _tokenId);
    //    (address transferTaxReceiver, uint256 transferTax) = cadastre().royaltyInfo(_tokenId, _salePrice);
    //    require(transferTaxReceiver != address(0) && transferTax > 0, "invalid transfer tax information");
    //    return (transferTaxReceiver, transferTax);
    //}

    //function isAuctionInAction(uint256 _tokenId) public view returns (bool) {
    //    return auction().getStartTime(_tokenId) > 0;
    //}

    ////          xxxxxxxxxxx                xxxxxxxxxxxxx
    //// INTERNAL & PRIVATE
    ////                          xxxxxxxxxxxxx               xxxxxxxxxxxxx

    //function _getNow() internal view returns (uint256) {
    //    return block.timestamp;
    //}

    //function _purchaseRealEstate(address _buyer, uint256 _tokenId, uint256 _salePrice) internal {
    //    Listing storage s_listing = s_listings[_tokenId];

    //    s_listing.stage = Stage.coolingOffPeriod;

    //    if (
    //        IERC20(s_listing.currency).transferFrom(
    //            _buyer,
    //            address(this),
    //            _salePrice
    //        ) == false) {
    //        revert RealEstatePurchaseFailed();
    //    }
    //}

    //function _transferNftFrom(address _seller, address _buyer, uint256 _tokenId) internal {
    //    IERC721(cadastre()).transferFrom(_seller, _buyer, _tokenId);
    //}

    //function checkUpkeep(bytes calldata _checkData)
    //    external
    //    view
    //    override
    //    returns (bool upkeepNeeded, bytes memory performData)
    //{
    //    uint256 tokenId = abi.decode(_checkData, (uint256));
    //    Listing memory listing = s_listings[tokenId];

    //    upkeepNeeded = block.timestamp > (listing.purchaseTime + listing.coolingOffPeriod);

    //    return (
    //        upkeepNeeded,
    //        abi.encode(tokenId)
    //    );
    //}

    //function performUpkeep(bytes calldata _performData) external override {
    //    uint256 tokenId = abi.decode(_performData, (uint256));
    //    Listing memory listing = s_listings[tokenId];

    //    require(msg.sender != address(0), "invalid caller");
    //    _validateIsExistentListing(tokenId);
    //    require(listing.stage == Stage.coolingOffPeriod, "invalid stage");
    //    require(block.timestamp > (listing.purchaseTime + listing.coolingOffPeriod), "invalid time");

    //    s_listings[tokenId].stage = Stage.sold;
    //    s_listings[tokenId].exists = false;

    //    uint256 marketplaceCommission = getMarketplaceCommission(listing.purchasePrice);
    //    s_marketplaceProceeds[listing.currency] += marketplaceCommission;

    //    (address transferTaxReceiver, uint256 transferTax) = getTransferTaxInfo(
    //        listing.buyer, tokenId, listing.purchasePrice - marketplaceCommission
    //    );
    //    s_transferTaxes[transferTaxReceiver][listing.currency] += transferTax;

    //    _transferNftFrom(listing.seller, listing.buyer, tokenId);

    //    uint256 amount = listing.purchasePrice - marketplaceCommission - transferTax;
    //    s_sellerProceeds[listing.seller][listing.currency] += amount;

    //    emit RealEstateSold(
    //        listing.buyer,
    //        listing.seller,
    //        listing.tokenId,
    //        listing.purchaseTime,
    //        listing.purchasePrice,
    //        Stage.sold
    //    );

    //    delete s_listings[tokenId];
    //}

    ///// @notice Validate whether `_currency` is a supported by marketplace payment currency.
    ///// @param _currency Supported by marketplace ERC-20 smart contract currency address.
    //function _validateIsAllowedCurrency(address _currency) internal view {
    //    if (currencyRegistry().isAllowed(_currency) == false) {
    //        revert InvalidCurrency(_currency);
    //    }
    //}

    ///// @notice Validate whether `_buyer` has sufficient `_salePrice` funds in `_currency`
    /////         to purchase a particular Real Estate.
    /////
    ///// @param _buyer Potential buyer of a particular Real Estate.
    ///// @param _currency Supported by marketplace ERC-20 smart contract currency address.
    ///// @param _salePrice Sale price of a particular Real Estate.
    //function _validateHasSufficientFunds(address _buyer, address _currency, uint256 _salePrice)
    //    internal
    //    view
    //{
    //    uint256 availableFunds = IERC20(_currency).balanceOf(_buyer);

    //    if (_salePrice > availableFunds) {
    //        revert InsufficientFunds(_salePrice, availableFunds);
    //    }
    //}

    //function _validateIsPriceGreaterThanZero(uint256 _price) internal pure {
    //    if (0 >= _price) {
    //        revert PriceMustBeGreaterThanZero();
    //    }
    //}

    //function _validateIsNotAuctionInAction(uint256 _tokenId) internal view {
    //    if (auction().getStartTime(_tokenId) > 0) { revert AuctionIsInAction(_tokenId); }
    //}

    //function _validateIsListingCurrency(address _currency, uint256 _tokenId) internal view {
    //    Listing memory listing = s_listings[_tokenId];

    //    if (listing.currency != _currency) {
    //        revert InvalidCurrency(_currency);
    //    }
    //}

    //function _validateIsExistentOffer(address _offerer, uint256 _tokenId) internal view {
    //    Offer memory offer = s_offers[_tokenId][_offerer];

    //    if (
    //        !offer.exists
    //        || offer.offerer == address(0)
    //        || offer.currency == address(0)
    //        || 0 >= offer.price
    //        || _getNow() > offer.expiry
    //    ) {
    //        revert OfferNotExists(_offerer, _tokenId);
    //    }
    //}

    //function _validateIsNonExistentOffer(address _offerer, uint256 _tokenId) internal view {
    //    Offer memory offer = s_offers[_tokenId][_offerer];

    //    if (
    //        offer.exists
    //        || offer.offerer != address(0)
    //        || offer.currency != address(0)
    //        || offer.price > 0
    //        || offer.expiry > _getNow()
    //    ) {
    //        revert OfferAlreadyExists(_offerer, _tokenId);
    //    }
    //}

    //function _validateIsExistentListing(uint256 _tokenId) internal view {
    //    Listing memory listing = s_listings[_tokenId];

    //    if (
    //        !listing.exists
    //        || 0 >= listing.initialPrice
    //        || listing.currency == address(0)
    //        || listing.seller == address(0)
    //    ) {
    //        revert ListingNotExists(_tokenId);
    //    }
    //}

    //function _validateIsNonExistentListing(uint256 _tokenId) internal view {
    //    Listing memory listing = s_listings[_tokenId];

    //    if (
    //        listing.exists
    //        || listing.initialPrice > 0
    //        || listing.currency != address(0)
    //        || listing.seller != address(0)
    //    ) {
    //        revert ListingAlreadyExists(_tokenId);
    //    }
    //}

    ///// @notice Validate whether `_current` listing stage is equal to `_required` listing stage.
    ///// @param _current Current listing stage.
    ///// @param _required Listing stage that is required in a listing process.
    //function _validateListingStage(Stage _current, Stage _required) internal pure {
    //    if (_current != _required) {
    //        revert InvalidListingStage(_current, _required);
    //    }
    //}

    ///// @notice Validate whether `_msgSender` is equal to `_required` message sender.
    ///// @param _msgSender Actual function caller.
    ///// @param _required Required function caller.
    //function _validateMsgSender(address _msgSender, address _required) internal pure {
    //    if (_msgSender != _required) {
    //        revert InvalidMsgSender(_msgSender, _required);
    //    }
    //}
}
