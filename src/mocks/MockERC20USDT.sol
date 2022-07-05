// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20USDT is ERC20 {
    constructor(address _to, uint256 _amount)
        public
        ERC20("Mock ERC20 USDT", "USDT")
    {
        _mint(_to, _amount);
    }
}
