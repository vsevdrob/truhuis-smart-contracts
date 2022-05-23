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

abstract contract TruhuisAddressRegistryAdapter is Ownable {
    ITruhuisAddressRegistry private _addressRegistry;

    function updateAddressRegistry(address _registry) public virtual onlyOwner {
        _updateAddressRegistry(_registry);
    }

    function auction() public view virtual returns (ITruhuisAuction) {
        return ITruhuisAuction(_addressRegistry.auction());
    }

    function addressRegistry() public view virtual returns (ITruhuisAddressRegistry) {
        return _addressRegistry;
    }

    function citizen(address _citizen) public view virtual returns (ICitizen) {
        return ICitizen(_citizen);
    }

    function currencyRegistry() public view virtual returns (ITruhuisCurrencyRegistry) {
        return ITruhuisCurrencyRegistry(_addressRegistry.currencyRegistry());
    }

    function stateGovernment(bytes3 _country) public view virtual returns (IStateGovernment) {
        return IStateGovernment(_addressRegistry.stateGovernment(_country));
    }

    function cadastre() public view virtual returns (ITruhuisCadastre) {
        return ITruhuisCadastre(_addressRegistry.cadastre());
    }

    function marketplace() public view virtual returns (ITruhuisMarketplace) {
        return ITruhuisMarketplace(_addressRegistry.marketplace());
    }

    function _updateAddressRegistry(address _registry) internal virtual {
        _addressRegistry = ITruhuisAddressRegistry(_registry);
    }
}
