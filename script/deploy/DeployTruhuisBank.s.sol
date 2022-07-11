// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/bank/TruhuisBank.sol";

contract DeployTruhuisBank is Script {
    function deploy(address _addresser) external {
        vm.startBroadcast();

        new TruhuisBank(_addresser);

        vm.stopBroadcast();
    }
}

