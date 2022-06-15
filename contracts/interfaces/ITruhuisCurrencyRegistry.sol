// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

interface ITruhuisCurrencyRegistry {
    function isAllowed(address _tokenAddr) external view returns (bool);
}
