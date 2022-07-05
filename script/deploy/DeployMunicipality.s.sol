// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/state/Municipality.sol";

contract DeployMunicipality is Script {
    function deploy(bytes4 _identifier)
        external
    {
        vm.startBroadcast();

        new Municipality(_identifier);

        vm.stopBroadcast();
    }
}
