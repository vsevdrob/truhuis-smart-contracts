// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {
    PurchaseAgreementStruct
} from "../../../interfaces/IPurchaseAgreement.sol";

contract PurchaseAgreementStorage {
    mapping(uint256 => PurchaseAgreementStruct) internal _sPurchaseAgreements;

    uint256 internal _sPurchaseAgreementIds;
}
