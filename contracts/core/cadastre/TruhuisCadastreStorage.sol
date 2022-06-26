// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

contract TruhuisCadastreStorage {
    /// @dev Token ID => Account => Whether granted or not
    mapping(uint256 => mapping(address => bool)) internal _sDidAllow;

    uint256 internal _sTokenIdCounter;
    string internal _sContractURI;
}
