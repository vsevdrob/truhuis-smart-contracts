// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../../../interfaces/ICitizen.sol";
import "../../../interfaces/IStateGovernment.sol";
import "../../../interfaces/ITruhuisAddressRegistry.sol";
import "../../../interfaces/ITruhuisAuction.sol";
import "../../../interfaces/ITruhuisCurrencyRegistry.sol";
import "../../../interfaces/ITruhuisCadastre.sol";
import "../../../interfaces/ITruhuisMarketplace.sol";

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
    function updateAddressRegistry(address _registry) public onlyOwner {
        _addressRegistry = ITruhuisAddressRegistry(_registry);
    }

    /// @notice Returns Truhuis Address Registry smart contract interface.
    function addressRegistry() public view returns (ITruhuisAddressRegistry) {
        return _addressRegistry;
    }

    /// @notice Returns Truhuis Auction smart contract interface.
    function auction() public view returns (ITruhuisAuction) {
        return ITruhuisAuction(_addressRegistry.auction());
    }

    /// @notice Returns Citizen smart contract interface specified by
    ///         the Citizen smart contract address.
    ///
    /// @param _citizen A Citizen smart contract address.
    function citizen(address _citizen) public view returns (ICitizen) {
        return ICitizen(_citizen);
    }

    /// @notice Returns Truhuis Currency Registry smart contract interface.
    function currencyRegistry() public view returns (ITruhuisCurrencyRegistry) {
        return ITruhuisCurrencyRegistry(_addressRegistry.currencyRegistry());
    }

    /// @notice Returns State Government smart contract interface specified by
    ///         the State Government smart contract address.
    ///
    /// @param _country Country in the form of ISO 3166-1 Alpha-3 code (e.g. "NLD" or "BEL")
    ///        to which the state government belongs.
    function stateGovernment(bytes3 _country) public view returns (IStateGovernment) {
        return IStateGovernment(_addressRegistry.stateGovernment(_country));
    }

    /// @notice Returns Truhuis Cadastre smart contract interface.
    function cadastre() public view returns (ITruhuisCadastre) {
        return ITruhuisCadastre(_addressRegistry.cadastre());
    }

    /// @notice Returns Truhuis Marketplace smart contract interface.
    function marketplace() public view returns (ITruhuisMarketplace) {
        return ITruhuisMarketplace(_addressRegistry.marketplace());
    }
}
