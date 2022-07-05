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

    /// @inheritdoc ITruhuisAddressRegistry
    function getAddress(bytes32 _id) external view override returns (address) {
        return _getAddress(_id);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function getMunicipalityContractAddr(bytes4 _cbsCode)
        external
        view
        override
        returns (address)
    {
        return _getMunicipalityContractAddr(_cbsCode);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function isRegisteredMunicipality(address _addr, bytes4 _cbsCode)
        external
        view
        override
        returns (bool)
    {
        return _isRegisteredMunicipality(_addr, _cbsCode);
    }
}
