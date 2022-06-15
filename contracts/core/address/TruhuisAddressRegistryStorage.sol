// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../../interfaces/ITruhuisAddressRegistry.sol";

/** 
 * @title TruhuisAddressRegistryStorage
 * @author
 *
 * @notice This is an abstract contract that *only* contains storage for the
 *         Truhuis Address Registry smart contract. This *must* be inherited
 *         last (bar interfaces) in order to preserve the Truhuis Address
 *         Registry storage layout. Adding storage variables should be done
 *         solely at the bottom of this smart contract.
 */
contract TruhuisAddressRegistryStorage {
    /// @dev CBS-code => Municipality
    mapping(uint16 => ITruhuisAddressRegistry.Municipality)
        internal _sMunicipalities;

    address internal _sAuction;
    address internal _sBank;
    address internal _sCadastre;
    address internal _sCurrencyRegistry;
    address internal _sMarketplace;
    address internal _sPersonalRecordsDatabase;
    address internal _sTaxAdministration;
}

