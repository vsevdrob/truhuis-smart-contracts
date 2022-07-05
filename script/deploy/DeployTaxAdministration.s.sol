// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/state/TaxAdministration.sol";

contract DeployTaxAdministration is Script {
    function deploy()
        external
    {
        vm.startBroadcast();

        new TaxAdministration();

        vm.stopBroadcast();
    }
}
