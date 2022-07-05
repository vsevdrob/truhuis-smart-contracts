// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../../interfaces/IMunicipality.sol";
import "../../interfaces/IPersonalRecordsDatabase.sol";
import "../../interfaces/ITaxAdministration.sol";
import "../../interfaces/ITruhuisAddressRegistry.sol";
import "../../interfaces/ITruhuisAppraiser.sol";
import "../../interfaces/ITruhuisAuction.sol";
import "../../interfaces/ITruhuisBank.sol";
import "../../interfaces/ITruhuisCadastre.sol";
import "../../interfaces/ITruhuisCurrencyRegistry.sol";
import "../../interfaces/ITruhuisInspector.sol";
import "../../interfaces/ITruhuisNotary.sol";
import "../../interfaces/ITruhuisTrade.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Truhuis AddressRegistry Adapter abstract smart contract.
/// @notice This contract deployed in order to be able to perform the necessary
///         smart contract function calls in the most convenient way.
abstract contract TruhuisAddressRegistryAdapter is Ownable {
    /// @notice Reverted if an address registry update fails.
    error TruhuisAddressRegistryAdapter__AddressRegistryUpdateFailed();

    /// @notice Truhuis Address Registry smart contract address.
    ITruhuisAddressRegistry private _addressRegistry;

    /// @notice Event emitted when an address registry update occurs.
    event AddressRegistryUpdated(address contractAddr);

    /// @notice Update Truhuis Address Registry smart contract address.
    /// @param _registry The new Truhuis Address Registry smart contract
    ///        address.
    /// @dev Only owner is able to call this function.
    function updateAddressRegistry(address _registry) public virtual onlyOwner {
        _addressRegistry = ITruhuisAddressRegistry(_registry);
    }

    /// @notice Returns Truhuis Address Registry smart contract interface.
    function addressRegistry()
        public
        view
        virtual
        returns (ITruhuisAddressRegistry)
    {
        return _addressRegistry;
    }

    /// @notice Returns Truhuis Appraiser smart contract interface.
    function appraiser() public view virtual returns (ITruhuisAppraiser) {
        return
            ITruhuisAppraiser(
                _addressRegistry.getAddress(bytes32("APPRAISER"))
            );
    }

    /// @notice Returns Truhuis Bank smart contract interface.
    function bank() public view virtual returns (ITruhuisBank) {
        return ITruhuisBank(_addressRegistry.getAddress(bytes32("BANK")));
    }

    /// @notice Returns Truhuis Currency Registry smart contract interface.
    function currencyRegistry()
        public
        view
        virtual
        returns (ITruhuisCurrencyRegistry)
    {
        return
            ITruhuisCurrencyRegistry(
                _addressRegistry.getAddress(bytes32("CURRENCY_REGISTRY"))
            );
    }

    /// @notice Returns Truhuis Cadastre smart contract interface.
    function cadastre() public view virtual returns (ITruhuisCadastre) {
        return
            ITruhuisCadastre(_addressRegistry.getAddress(bytes32("CADASTRE")));
    }

    /// @notice Returns Truhuis Inspector smart contract interface.
    function inspector() public view virtual returns (ITruhuisInspector) {
        return
            ITruhuisInspector(
                _addressRegistry.getAddress(bytes32("INSPECTOR"))
            );
    }

    function municipality(address _addr)
        public
        view
        virtual
        returns (IMunicipality)
    {
        return IMunicipality(_addr);
    }

    /// @notice _
    function notary() public view virtual returns (ITruhuisNotary) {
        return ITruhuisNotary(_addressRegistry.getAddress(bytes32("NOTARY")));
    }

    /// @notice Returns Personal Records Database smart contract interface.
    function personalRecordsDatabase()
        public
        view
        virtual
        returns (IPersonalRecordsDatabase)
    {
        return
            IPersonalRecordsDatabase(
                _addressRegistry.getAddress(
                    bytes32("PERSONAL_RECORDS_DATABASE")
                )
            );
    }

    /// @notice Returns Tax Administration smart contract interface.
    function taxAdministration()
        public
        view
        virtual
        returns (ITaxAdministration)
    {
        return
            ITaxAdministration(
                _addressRegistry.getAddress(bytes32("TAX_ADMINISTRATION"))
            );
    }

    /// @notice Returns Truhuis Marketplace smart contract interface.
    function trade() public view virtual returns (ITruhuisTrade) {
        return
            ITruhuisTrade(_addressRegistry.getAddress(bytes32("TRADE")));
    }
}
