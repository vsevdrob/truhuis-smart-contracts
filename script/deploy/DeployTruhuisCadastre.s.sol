// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/cadastre/TruhuisCadastre.sol";

contract DeployTruhuisCadastre is Script {
    function deploy(address _addresser, string memory _contractURI)
        external
    {
        vm.startBroadcast();

        new TruhuisCadastre(_addresser, _contractURI);

        vm.stopBroadcast();
    }
}
