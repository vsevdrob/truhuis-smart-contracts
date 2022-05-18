// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../../../interfaces/ICitizen.sol";
import "../../../interfaces/IGovernment.sol";
import "../../../interfaces/ITruhuisAddressRegistry.sol";
import "../../../interfaces/ITruhuisAuction.sol";
import "../../../interfaces/ITruhuisCurrencyRegistry.sol";
import "../../../interfaces/ITruhuisLandRegistry.sol";
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

    function citizen(address _account) public view virtual returns (ICitizen) {
        return ICitizen(_account);
    }

    function currencyRegistry() public view virtual returns (ITruhuisCurrencyRegistry) {
        return ITruhuisCurrencyRegistry(_addressRegistry.currencyRegistry());
    }

    function government(string calldata _country) public view virtual returns (IGovernment) {
        return IGovernment(_addressRegistry.government(_country));
    }

    function landRegistry() public view virtual returns (ITruhuisLandRegistry) {
        return ITruhuisLandRegistry(_addressRegistry.landRegistry());
    }

    function marketplace() public view virtual returns (ITruhuisMarketplace) {
        return ITruhuisMarketplace(_addressRegistry.marketplace());
    }

    function _updateAddressRegistry(address _registry) internal virtual {
        _addressRegistry = ITruhuisAddressRegistry(_registry);
    }
}
