// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

interface ITaxAdministration {
    event TaxUpdated(uint256 _id, uint96 _tax);

    /**
     * @dev _
     */
    function updateTax(uint256 _id, uint96 _tax) external;

    /**
     * @dev _
     */
    function getTax(uint256 _id)
        external
        view
        returns (uint96);
}
