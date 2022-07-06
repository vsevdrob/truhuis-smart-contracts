// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./ATruhuisAddressRegistry.sol";

/// @title TruhuisAddressRegistry
/// @author vsevdrob
/// @notice This contract deployed in order to implement parameterization method
///         of upgradable smart contracts by performing addresses registrations.
contract TruhuisAddressRegistry is ATruhuisAddressRegistry {
    constructor() {
        _initialize();
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function registerMunicipality(address _contractAddr, bytes4 _cbsCode)
        external
        onlyOwner
    {
        _registerMunicipality(_contractAddr, _cbsCode);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function updateAddress(address _newAddr, bytes32 _id)
        external
        override
        onlyOwner
    {
        _updateAddress(_newAddr, _id);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function updateMunicipality(address _newAddr, bytes4 _cbsCode)
        external
        override
        onlyOwner
    {
        _updateMunicipality(_newAddr, _cbsCode);
    }
}
