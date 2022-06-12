// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../../../interfaces/IResident.sol";
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

    /// @notice Returns Resident smart contract interface specified by
    ///         the Resident smart contract address.
    ///
    /// @param _resident A Resident smart contract address.
    function resident(address _resident) public view returns (IResident) {
        return IResident(_resident);
    }

    /// @notice Returns Truhuis Currency Registry smart contract interface.
    function currencyRegistry() public view returns (ITruhuisCurrencyRegistry) {
        return ITruhuisCurrencyRegistry(_addressRegistry.currencyRegistry());
    }

    /// @notice Returns State Government smart contract interface specified by
    ///         the State Government smart contract address.
    ///
    /// @param _stateGovernmentContractAddr The State Government smart contract address.
    function stateGovernment(address _stateGovernmentContractAddr) public view returns (IStateGovernment) {
        return IStateGovernment(_stateGovernmentContractAddr);
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
