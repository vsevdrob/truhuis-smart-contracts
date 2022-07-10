// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@core/addresser/TruhuisAddresserAPI.sol";

/// @notice Reverted if `account` is a smart contract, not an account (human).
error AccountIsNotHuman(address account);
/// @notice Reverted if `account` is equal to actual `tokenId` property owner.
error AccountIsPropertyOwner(address account, uint256 tokenId);
/// @notice Reverted if `account` is not equal to actual `tokenId` property owner.
error AccountIsNotPropertyOwner(address account, uint256 tokenId);
/// @notice Reverted if `buyer` is not allowed to purchase `tokenId` Real Estate.
error BuyerIsNotAllowedToPurchaseRealEstate(address buyer, uint256 tokenId);
/// @notice Reverted if `seller` is not allowed to sell `tokenId` Real Estate.
error SellerIsNotAllowedToSellRealEstate(address seller, uint256 tokenId);
/// @notice Reverted if marketplace is not approved to transfer `tokenId`.
error MarketplaceIsNotApproved(uint256 tokenId);

abstract contract IdentificationLogic is TruhuisAddresserAPI {
    modifier onlyBuyer(address _buyer, uint256 _tokenId) {
        _identifyBuyer(_buyer, _tokenId);
        _;
    }

    modifier onlySeller(address _seller, uint256 _tokenId) {
        _identifySeller(_seller, _tokenId);
        _;
    }

    /// @notice Identify `_buyer` as a resident of a state and ensure that
    ///         `_buyer` is allowed to purchase `_tokenId` Real Estatte within the state.
    ///
    /// @param _buyer Buyer account address. `_buyer` is not allowed to be a smart contract.
    /// @param _tokenId NFT ID that was issued by Truhuis Cadastre smart contract.
    ///
    /// Requirements:
    ///
    /// - `_buyer` cannot be the zero address.
    /// - `_buyer` cannot be a smart contract.
    /// - `_buyer` should be allowed to purchase `_tokenId` by:
    ///     - `StateGovernment` wherein the `_buyer` residents.
    ///     - `TruhuisBank`
    ///     - `TruhuisCadastre`
    function _identifyBuyer(address _buyer, uint256 _tokenId) internal view {
        // Ensure that `_buyer` is not a smart contract, but a human.

        uint256 codeLength;
        assembly {
            codeLength := extcodesize(_buyer)
        }
        if (codeLength != 0 || _buyer == address(0))
            revert AccountIsNotHuman(_buyer);

        // Ensure that `_buyer` is not (already) `_tokenId` property owner.

        if (cadastre().isNFTOwner(_buyer, _tokenId))
            revert AccountIsPropertyOwner(_buyer, _tokenId);

        // Ensure that `_buyer` is allowed to purchase `_tokenId` Real Estate.

        if (!personalRecordsDatabase().isDutchNationality(_buyer)) {
            revert BuyerIsNotAllowedToPurchaseRealEstate(_buyer, _tokenId);
        }
    }

    /// @notice Identify `_seller` as a resident of a state and ensure that
    ///         `_seller` is allowed to sell `_tokenId` Real Estatte within the state.
    ///
    /// @param _seller Seller account address. `_seller` is not allowed to be a smart contract
    /// @param _tokenId NFT ID that was issued by Truhuis Cadastre smart contract.
    ///
    /// Requirements:
    ///
    /// - `_seller` cannot be the zero address.
    /// - `_seller` cannot be a smart contract.
    /// - `_seller` should be allowed to sell `_tokenId` by:
    ///     - `StateGovernment` wherein the `_seller` residents.
    ///     - `TruhuisBank`
    ///     - `TruhuisCadastre`
    /// - `TruhuisMarketplace` must be approved by `_seller` to transfer `_tokenId`.
    function _identifySeller(address _seller, uint256 _tokenId) internal view {
        // Ensure that `_seller` is not a smart contract, but a human.

        uint256 codeLength;
        assembly {
            codeLength := extcodesize(_seller)
        }
        if (codeLength != 0 || _seller == address(0))
            revert AccountIsNotHuman(_seller);

        // Validate that `_seller` is the `_tokenId` property owner.

        if (!cadastre().isNFTOwner(_seller, _tokenId))
            revert AccountIsNotPropertyOwner(_seller, _tokenId);

        // Ensure that `_seller` is a resident of the country wherein `_tokenId` Real Estate is located.
        // Ensure that `_seller` is allowed to sell `_tokenId` Real Estate.

        if (!personalRecordsDatabase().isDutchNationality(_seller)) {
            revert SellerIsNotAllowedToSellRealEstate(_seller, _tokenId);
        }

        // Ensure that Truhuis Marketplace is approved to transfer `_tokenId`.

        if (
            cadastre().isApprovedForAll(
                cadastre().ownerOf(_tokenId),
                address(this)
            ) || cadastre().getApproved(_tokenId) == address(this)
        ) revert MarketplaceIsNotApproved(_tokenId);
    }
}
