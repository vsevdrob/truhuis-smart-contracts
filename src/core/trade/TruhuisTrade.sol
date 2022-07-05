// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./TruhuisAuction.sol";
import "./TruhuisMarketplace.sol";

/**
 * @title TruhuisTrade
 * @author vsevdrob
 * @notice _
 */
contract TruhuisTrade is TruhuisMarketplace {
    constructor(address _addressRegistry, uint96 _serviceFee)
        TruhuisMarketplace(_addressRegistry, _serviceFee)
    {}
}
