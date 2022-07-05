// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./IPurchaseAgreement.sol";
import "./IDeedOfDelivery.sol";
//import {PurchaseAgreementStruct} from "./IPurchaseAgreement.sol";

interface ITruhuisNotary is IPurchaseAgreement, IDeedOfDelivery {
    /**
     * @dev _
     */
    function drawUpDeedOfDelivery(
        uint256 _purchaseAgreementId,
        uint256 _txId
    ) external;

    /**
     * @dev _
     */
    function drawUpPurchaseAgreement(
        PurchaseAgreementStruct memory _purchaseAgreement
    ) external;
}
