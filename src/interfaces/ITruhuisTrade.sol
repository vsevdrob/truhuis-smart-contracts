// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "./ITruhuisMarketplace.sol";
import "./ITruhuisAuction.sol";

interface ITruhuisTrade is ITruhuisAuction, ITruhuisMarketplace {}
