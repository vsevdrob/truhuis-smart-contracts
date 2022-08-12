// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

/// @dev Reverted if municipality registration is failed.
error MUNICIPALITY_REGISTRATION_FAILED();

/// @dev Reverted if municipality update is failed.
error MUNICIPALITY_UPDATE_FAILED();

/// @dev Reverted if provided address is identical to old address.
error IDENTICAL_ADDRESS_PROVIDED();

/// @dev Reverted if attempted to update Truhuis Addresser address.
error UPDATE_ADDRESSER_NOT_ALLOWED();

/// @dev Reverted if provided address is the zero address.
error ZERO_ADDRESS_PROVIDED();

/// @notice Municipality struct.
struct MunicipalityStruct {
    address contractAddr;
    bool isRegistered;
    bytes4 cbsCode;
}

interface ITruhuisAddresser {
    /// @notice Event emitted when an address update takes place.
    event AddressUpdated(address newAddr, address oldAddr, bytes32 id);

    /// @notice Event emitted when a municipality registration occurs.
    event MunicipalityRegistered(address contractAddr, bytes4 cbsCode);

    /// @notice Event emitted when a municipality update occurs.
    event MunicipalityUpdated(address newAddr, address oldAddr, bytes4 cbsCode);

    /**
     * @dev Register new municipality.
     * @param _addr Contract address of the municipality.
     * @param _cbsCode CBS-code identifier for the municipality.
     */
    function registerMunicipality(address _addr, bytes4 _cbsCode)
        external;

    /**
     * @dev Update contract address.
     * @param _newAddr New contract address of the contract.
     * @param _id Bytes 32 identifier for the contract.
     */
    function updateAddress(address _newAddr, bytes32 _id) external;

    /**
     * @dev Update municipality contract address.
     * @param _newAddr New contract address of the municipality.
     * @param _cbsCode CBS-code identifier of the municipality.
     */
    function updateMunicipality(address _newAddr, bytes4 _cbsCode)
        external;

    /**
     * @dev Get contract address specified by contract identifier.
     * @param _id Contract identifier.
     */
    function getAddress(bytes32 _id) external view returns (address);

    /**
     * @dev Get contract address of municipality specified by CBS-code
     *      identifier.
     * @param _cbsCode CBS-code identifier of the municipality.
     */
    function getMunicipality(bytes4 _cbsCode)
        external
        view
        returns (MunicipalityStruct memory);

    /**
     * @dev Get whether municipality is registered or not.
     * @param _addr Contract address of the municipality.
     * @param _cbsCode CBS-code identifier for the municipality.
     */
    function isRegisteredMunicipality(address _addr, bytes4 _cbsCode)
        external
        view
        returns (bool);
}
