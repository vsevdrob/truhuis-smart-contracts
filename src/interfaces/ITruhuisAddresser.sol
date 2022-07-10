// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

/// @dev Reverted if municipality registration is failed.
error MUNICIPALITY_REGISTRATION_FAILED();

/// @dev Reverted if municipality update is failed.
error MUNICIPALITY_UPDATE_FAILED();

/// @dev Reverted if provided address is identical to old address.
error IDENTICAL_ADDRESS_PROVIDED();

/// @dev Reverted if attempted to update Truhuis Address Registry address.
error UPDATE_ADDRESS_REGISTRY_NOT_ALLOWED();

/// @dev Reverted if provided address is the zero address.
error ZERO_ADDRESS_PROVIDED();

/// @notice Municipality struct.
struct MunicipalityStruct {
    address contractAddr;
    bool isRegistered;
    bytes4 cbsCode;
}

interface ITruhuisAddressRegistry {
    /// @notice Event emitted when an address update takes place.
    event AddressUpdated(address newAddr, address oldAddr, bytes32 id);

    /// @notice Event emitted when a municipality registration occurs.
    event MunicipalityRegistered(address contractAddr, bytes4 cbsCode);

    /// @notice Event emitted when a municipality update occurs.
    event MunicipalityUpdated(address newAddr, address oldAddr, bytes4 cbsCode);

    /**
     * @dev _
     */
    function registerMunicipality(address _addr, bytes4 _cbsCode)
        external;

    /**
     * @dev _
     */
    function updateAddress(address _newAddr, bytes32 _id) external;

    /**
     * @dev _
     */
    function updateMunicipality(address _newAddr, bytes4 _cbsCode)
        external;

    /**
     * @dev _
     */
    function getAddress(bytes32 _id) external view returns (address);

    /**
     * @dev _
     */
    function getMunicipality(bytes4 _cbsCode)
        external
        view
        returns (MunicipalityStruct memory);

    /**
     * @dev _
     */
    function isRegisteredMunicipality(address _addr, bytes4 _cbsCode)
        external
        view
        returns (bool);
}
