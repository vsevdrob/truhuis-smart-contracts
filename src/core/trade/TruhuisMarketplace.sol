// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./ATruhuisMarketplace.sol";

/**
 * @title TruhuisMarketplace
 * @author vsevdrob
 * @notice _
 */
contract TruhuisMarketplace is ATruhuisMarketplace {
    constructor(address _addresser, uint96 _serviceFee)
        ATruhuisMarketplace(_addresser, _serviceFee)
    {}

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
        uint256 _bidPrice,
        uint256 _tokenId
    ) external override onlyBuyer(msg.sender, _tokenId) {
        _createOffer(_currency, _expiry, _bidPrice, _tokenId);
    }

    /// @inheritdoc ITruhuisMarketplace
    function list(
        address _currency,
        uint256 _askPrice,
        uint256 _tokenId
    ) external override onlySeller(msg.sender, _tokenId) {
        _list(_currency, _askPrice, _tokenId);
    }

    /// @inheritdoc ITruhuisMarketplace
    function setListingSold(uint256 _tokenId) external override {
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
    function updateListingPrice(uint256 _newAskPrice, uint256 _tokenId)
        external
        override
        onlySeller(msg.sender, _tokenId)
    {
        _updateListingPrice(_newAskPrice, _tokenId);
    }

    /// @inheritdoc ITruhuisMarketplace
    function updateServiceFee(uint96 _newServiceFee)
        external
        override
        onlyOwner
    {
        _updateServiceFee(_newServiceFee);
    }
}
