// SPDX-License-Idetifier: MIT
pragma solidity 0.8.13;

interface IPriceConsumerV3 {
    function price(uint256 _id) external view returns (uint256);
}
