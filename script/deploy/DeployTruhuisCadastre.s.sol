// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/cadastre/TruhuisCadastre.sol";

contract DeployTruhuisCadastre is Script {
    function deploy(address _addressRegistry, string memory _contractURI)
        external
    {
        vm.startBroadcast();

        TruhuisCadastre cadastre = new TruhuisCadastre(
            _addressRegistry,
            _contractURI
        );

        vm.stopBroadcast();
    }
}
