// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "@core/trade/TruhuisTrade.sol";

contract DeployTruhuisTrade is Script {
    function deploy(address _addresser, uint96 _serviceFee)
        external
    {
        vm.startBroadcast();

        new TruhuisTrade(_addresser, _serviceFee);

        vm.stopBroadcast();
    }
}
