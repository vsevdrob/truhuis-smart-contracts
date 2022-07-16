// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "./ATaxAdministration.sol";

/**
 * @title TaxAdministration
 * @author vsevdrob
 * @notice _
 */
contract TaxAdministration is ATaxAdministration {
    constructor(address _addresser) ATaxAdministration(_addresser) {}

    /// @inheritdoc ITaxAdministration
    function updateTax(uint256 _id, uint96 _tax)
        external
        override
        onlyOwner
    {
        _updateTax(_id, _tax);
    }
}
