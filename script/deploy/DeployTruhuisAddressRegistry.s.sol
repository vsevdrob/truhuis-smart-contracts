// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/address/TruhuisAddressRegistry.sol";

contract DeployTruhuisAddressRegistry is Script {
    function deploy() external {
        vm.startBroadcast();

        TruhuisAddressRegistry addressRegistry = new TruhuisAddressRegistry();

        vm.stopBroadcast();
    }
}
