// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "./ATruhuisAppraiser.sol";

contract TruhuisAppraiser is ATruhuisAppraiser {
    constructor(address _addresser) ATruhuisAppraiser(_addresser) {}
}

