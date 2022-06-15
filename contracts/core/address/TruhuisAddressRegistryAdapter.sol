// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../../interfaces/IMunicipality.sol";
import "../../interfaces/IPersonalRecordsDatabase.sol";
import "../../interfaces/ITaxAdministration.sol";
import "../../interfaces/ITruhuisAddressRegistry.sol";
import "../../interfaces/ITruhuisAuction.sol";
import "../../interfaces/ITruhuisBank.sol";
import "../../interfaces/ITruhuisCurrencyRegistry.sol";
import "../../interfaces/ITruhuisCadastre.sol";
import "../../interfaces/ITruhuisMarketplace.sol";

/// @title Truhuis AddressRegistry Adapter abstract smart contract.
/// @notice This contract deployed in order to be able to perform the necessary
///         smart contract function calls in the most convenient way.
abstract contract TruhuisAddressRegistryAdapter is Ownable {
    /// @notice Reverted if an address registry update fails.
    error TruhuisAddressRegistryAdapter__AddressRegistryUpdateFailed();

    /// @notice Truhuis Address Registry smart contract address.
    ITruhuisAddressRegistry private _addressRegistry;

    /// @notice Event emitted when an address registry update occurs.
    event AddressRegistryUpdated(
        address contractAddr
    );

    /// @notice Update Truhuis Address Registry smart contract address.
    /// @param _registry The new Truhuis Address Registry smart contract address.
    /// @dev Only owner is able to call this function.
    function updateAddressRegistry(address _registry) public virtual onlyOwner {
        _addressRegistry = ITruhuisAddressRegistry(_registry);
    }

    /// @notice Returns Truhuis Address Registry smart contract interface.
    function addressRegistry() public view virtual returns (ITruhuisAddressRegistry) {
        return _addressRegistry;
    }

    /// @notice Returns Truhuis Auction smart contract interface.
    function auction() public view virtual returns (ITruhuisAuction) {
        return ITruhuisAuction(_addressRegistry.auction());
    }

    /// @notice Returns Truhuis Bank smart contract interface.
    function bank() public view virtual returns (ITruhuisBank) {
        return ITruhuisBank(_addressRegistry.bank());
    }

    /// @notice Returns Truhuis Currency Registry smart contract interface.
    function currencyRegistry() public view virtual returns (ITruhuisCurrencyRegistry) {
        return ITruhuisCurrencyRegistry(_addressRegistry.currencyRegistry());
    }

    /// @notice Returns Truhuis Cadastre smart contract interface.
    function cadastre() public view virtual returns (ITruhuisCadastre) {
        return ITruhuisCadastre(_addressRegistry.cadastre());
    }

    /// @notice Returns Truhuis Marketplace smart contract interface.
    function marketplace() public view virtual returns (ITruhuisMarketplace) {
        return ITruhuisMarketplace(_addressRegistry.marketplace());
    }

    /// @notice Returns Tax Administration smart contract interface.
    function taxAdministration() public view virtual returns (ITaxAdministration) {
        return ITaxAdministration(_addressRegistry.taxAdministration());
    }

    /// @notice Returns Personal Records Database smart contract interface.
    function personalRecordsDatabase() public view virtual returns (IPersonalRecordsDatabase) {
        return IPersonalRecordsDatabase(_addressRegistry.personalRecordsDatabase());
    }

    /// @notice Returns State Government smart contract interface specified by
    ///         the State Government smart contract address.
    ///
    /// @param _municipalityContractAddr The State Government smart contract address.
    function municipality(address _municipalityContractAddr) public view virtual returns (IMunicipality) {
        return IMunicipality(_municipalityContractAddr);
    }
}
