// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "./ATruhuisAddresser.sol";

/// @title TruhuisAddresser
/// @author vsevdrob
/// @notice This contract deployed in order to implement parameterization method
///         of upgradable smart contracts by performing addresses registrations.
contract TruhuisAddresser is ATruhuisAddresser {
    constructor() {
        _initialize();
    }

    /// @inheritdoc ITruhuisAddresser
    function registerMunicipality(address _contractAddr, bytes4 _cbsCode)
        external
        onlyOwner
    {
        _registerMunicipality(_contractAddr, _cbsCode);
    }

    /// @inheritdoc ITruhuisAddresser
    function updateAddress(address _newAddr, bytes32 _id)
        external
        override
        onlyOwner
    {
        _updateAddress(_newAddr, _id);
    }

    /// @inheritdoc ITruhuisAddresser
    function updateMunicipality(address _newAddr, bytes4 _cbsCode)
        external
        override
        onlyOwner
    {
        _updateMunicipality(_newAddr, _cbsCode);
    }
}
