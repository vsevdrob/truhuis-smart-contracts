// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {Costs} from "./Article02Costs.sol";

/**
 * @dev Article 3 Payment
 */
struct Payment {
    uint256 purchasePrice;
    Costs costs;
}

