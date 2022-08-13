// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/addresser/TruhuisAddresser.sol";

contract DeployTruhuisAddresser is Script {
    function deploy() external {
        vm.startBroadcast();

        new TruhuisAddresser();

        vm.stopBroadcast();
    }
}
