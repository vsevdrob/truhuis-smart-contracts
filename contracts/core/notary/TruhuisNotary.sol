// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {TruhuisNotaryStorage as Storage} from "./TruhuisNotaryStorage.sol";
import "./purchase-agreement/PurchaseAgreement.sol";

contract TruhuisNotary is PurchaseAgreement, Storage {
    function drawUpPurchaseAgreement(
        PurchaseAgreementStruct memory _purchaseAgreement
    ) external onlyOwner {
        _drawUpPurchaseAgreement(_purchaseAgreement);
    }
}
