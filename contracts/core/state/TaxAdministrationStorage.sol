// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

contract TaxAdministrationStorage {
    // e.g. 100 (1%); 1000 (10%)
    mapping(uint256 => uint96) internal  _sTransferTaxById;
}
