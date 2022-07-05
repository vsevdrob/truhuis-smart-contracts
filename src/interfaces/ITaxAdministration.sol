// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

interface ITaxAdministration {
    event TransferTaxUpdated(uint256 _id, uint96 _tax);

    /**
     * @dev _
     */
    function updateTransferTax(uint256 _id, uint96 _tax) external;

    /**
     * @dev _
     */
    function transferTax(/*address _person, uint256 _tokenId*/)
        external
        view
        returns (uint96);
}
