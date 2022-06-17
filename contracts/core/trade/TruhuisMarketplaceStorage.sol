// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {Listing} from "../../interfaces/ITruhuisMarketplace.sol";

/// @title TruhuisMarketplaceStorage
///
/// @notice This is an abstract contract that *only* contains storage for the
///         Truhuis Marketplace smart contract. This *must* be inherited last
///         (bar interfaces) in order to preserve the Truhuis Marketpalce
///         storage layout. Adding storage variables should be done solely at
///         the bottom of this smart contract.
contract TruhuisMarketplaceStorage {
    /// @dev Token ID => Listing struct
    mapping(uint256 => Listing) internal _sListings;

    ///// @dev seller => supported currency => allowed seller proceeds to withdraw
    //mapping(address => mapping(address => uint256)) public s_sellerProceeds;
    ///// @dev Transfer Tax Receiver => supported currency => allowed transfer taxes to withdraw
    //mapping(address => mapping(address => uint256)) public s_transferTaxes;
    ///// @dev Supported currency => allowed marketplace proceeds to withdraw
    //mapping(address => uint256) public s_marketplaceProceeds;

    ///// @dev Marketplace owner and Truhuis Marketplace service fee receiver.
    //address internal _sMarketplaceOwner;
    /// @dev Truhuis Marketplace service fee (e.g. 100 (1%); 1000 (10%)).
    uint96 internal _sMarketplaceServiceFee;
}
