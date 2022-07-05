// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/notary/TruhuisNotary.sol";

contract DeployTruhuisNotary is Script {
    function deploy(address _addressRegistry)
        external
    {
        vm.startBroadcast();

        new TruhuisNotary(_addressRegistry);

        vm.stopBroadcast();
    }
}
