// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@interfaces/ITruhuisAddresser.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ATruhuisAddresser
 * @author vsevdrob
 * @notice _
 */
abstract contract ATruhuisAddresser is Ownable, ITruhuisAddresser {
    /* PRIVATE STORAGE */

    /// @dev Identifier => Municipality struct.
    mapping(bytes4 => MunicipalityStruct) private _sMunicipalities;
    /// @dev Address identifier => Smart contract address.
    mapping(bytes32 => address) private _sAddresses;

    /// @dev Identifier for Truhuis Addresser smart contract.
    bytes32 private constant _S_ADDRESSER = "ADDRESSER";
    /// @dev Identifier for Truhuis Appraiser smart contract.
    bytes32 private constant _S_APPRAISER = "APPRAISER";
    /// @dev Identifier for Truhuis Bank smart contract.
    bytes32 private constant _S_BANK = "BANK";
    /// @dev Identifier for Truhuis Cadastre smart contract.
    bytes32 private constant _S_CADASTRE = "CADASTRE";
    /// @dev Identifier for Truhuis Inspector smart contract.
    bytes32 private constant _S_INSPECTOR = "INSPECTOR";
    /// @dev Identifier for Truhuis Notary smart contract.
    bytes32 private constant _S_NOTARY = "NOTARY";
    /// @dev Identifier for Personal Records Database smart contract.
    bytes32 private constant _S_PERSONAL_RECORDS_DATABASE =
        "PERSONAL RECORDS DATABASE";
    /// @dev Identifier for Chainlink Price Feed smart contract.
    bytes32 private constant _S_PRICE_ORACLE = "PRICE ORACLE";
    /// @dev Identifier for Tax Administration smart contract.
    bytes32 private constant _S_TAX_ADMINISTRATION = "TAX ADMINISTRATION";
    /// @dev Identifier for Truhuis Trade smart contract.
    bytes32 private constant _S_TRADE = "TRADE";

    /* EXTERNAL VIEW FUNCTIONS */

    ///@inheritdoc ITruhuisAddresser
    function getAddress(bytes32 _id) external view returns (address) {
        return _sAddresses[_id];
    }

    ///@inheritdoc ITruhuisAddresser
    function getMunicipality(bytes4 _cbsCode)
        external
        view
        override
        returns (MunicipalityStruct memory)
    {
        return _sMunicipalities[_cbsCode];
    }

    ///@inheritdoc ITruhuisAddresser
    function isRegisteredMunicipality(address _addr, bytes4 _cbsCode)
        external
        view
        override
        returns (bool)
    {
        /* ARRANGE */

        // Get municipality data specified by `_cbsCode`.
        MunicipalityStruct memory municipality = _sMunicipalities[_cbsCode];

        // Return false if not registered.
        if (
            municipality.contractAddr == _addr &&
            municipality.isRegistered &&
            municipality.cbsCode == _cbsCode
        ) {
            return true;
        }

        // Return false if not registered.
        return false;
    }

    /* INTERNAL FUNCTIONS */

    /**
     * @dev _
     */
    function _initialize() internal {
        _sAddresses[_S_ADDRESSER] = address(this);
    }

    /**
     * @dev _
     */
    function _registerMunicipality(address _addr, bytes4 _cbsCode) internal {
        /* ARRANGE */

        // Get municipality data specified by `_cbsCode`.
        MunicipalityStruct storage sMunicipality = _sMunicipalities[_cbsCode];

        /* PERFORM ASSERTIONS */

        // Municipality must be not already registered.
        if (
            sMunicipality.contractAddr == _addr ||
            sMunicipality.isRegistered == true ||
            sMunicipality.cbsCode == _cbsCode
        ) revert MUNICIPALITY_REGISTRATION_FAILED();

        /* REGISTER MUNICIPALITY */

        sMunicipality.contractAddr = _addr;
        sMunicipality.isRegistered = true;
        sMunicipality.cbsCode = _cbsCode;

        // Emit a {MunicipalityRegistered} event.
        emit MunicipalityRegistered(_addr, _cbsCode);
    }

    /**
     * @dev _
     */
    function _updateAddress(address _newAddr, bytes32 _id) internal {
        /* ARRANGE */

        // Get old address specified by ID.
        address oldAddr = _sAddresses[_id];

        /* PERFORM ASSERTIONS */

        // Update Truhuis Address is not allowed.
        if (_id == _S_ADDRESSER) {
            revert UPDATE_ADDRESSER_NOT_ALLOWED();
        }

        // The new address can not be identical to the old address.
        if (_newAddr == oldAddr) {
            revert IDENTICAL_ADDRESS_PROVIDED();
        }

        // The new address can not be the zero address.
        if (_newAddr == address(0)) {
            revert ZERO_ADDRESS_PROVIDED();
        }

        /* UPDATE ADDRESS */

        _sAddresses[_id] = _newAddr;

        // Emit an {AddressUpdated} event.
        emit AddressUpdated(_newAddr, oldAddr, _id);
    }

    /**
     * @dev _
     */
    function _updateMunicipality(address _newAddr, bytes4 _cbsCode) internal {
        /* ARRANGE */

        // Get municipality data specified by `_cbsCode`.
        MunicipalityStruct storage sMunicipality = _sMunicipalities[_cbsCode];

        // Get old address.
        address oldAddr = sMunicipality.contractAddr;

        /* PERFORM ASSERTIONS */

        // `_newAddr` must be not identical to the `oldAddr`.
        if (_newAddr == oldAddr) {
            revert MUNICIPALITY_UPDATE_FAILED();
        }

        // `_newAddr` must be not the zero address.
        if (_newAddr == address(0)) {
            revert ZERO_ADDRESS_PROVIDED();
        }

        /* UPDATE MUNICIPALITY */

        sMunicipality.contractAddr = _newAddr;

        // Emit a {MunicipalityUpdated} event.
        emit MunicipalityUpdated(_newAddr, oldAddr, _cbsCode);
    }
}
