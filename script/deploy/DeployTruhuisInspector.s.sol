// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/inspector/TruhuisInspector.sol";

contract DeployTruhuisInspector is Script {
    function deploy(address _addresser)
        external
    {
        vm.startBroadcast();

        new TruhuisInspector(_addresser);

        vm.stopBroadcast();
    }
}
