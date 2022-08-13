// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/state/PersonalRecordsDatabase.sol";

contract DeployPersonalRecordsDatabase is Script {
    function deploy(address _addresser)
        external
    {
        vm.startBroadcast();

        new PersonalRecordsDatabase(_addresser);

        vm.stopBroadcast();
    }
}
