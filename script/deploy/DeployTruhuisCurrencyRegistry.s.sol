// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/currency/TruhuisCurrencyRegistry.sol";

contract DeployTruhuisCurrencyRegistry is Script {
    function deploy()
        external
    {
        vm.startBroadcast();

        new TruhuisCurrencyRegistry();

        vm.stopBroadcast();
    }
}
