// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/notary/TruhuisNotary.sol";

contract DeployTruhuisNotary is Script {
    function deploy(address _addresser)
        external
    {
        vm.startBroadcast();

        new TruhuisNotary(_addresser);

        vm.stopBroadcast();
    }
}
