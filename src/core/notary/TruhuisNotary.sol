// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./purchase-agreement/PurchaseAgreement.sol";
import "./deed-of-delivery/DeedOfDelivery.sol";
import "../../interfaces/ITruhuisNotary.sol";

/**
 * @title TruhuisNotary
 * @author vsevdrob
 * @notice _
 */
contract TruhuisNotary is ITruhuisNotary, PurchaseAgreement, DeedOfDelivery {
    constructor(address _addressRegistry) {
        updateAddressRegistry(_addressRegistry);
    }

    /// @inheritdoc ITruhuisNotary
    function drawUpDeedOfDelivery(
        uint256 _purchaseAgreementId,
        uint256 _txId
    ) external onlyOwner {
        _drawUpDeedOfDelivery(_purchaseAgreementId, _txId);
    }

    /// @inheritdoc ITruhuisNotary
    function drawUpPurchaseAgreement(
        PurchaseAgreementStruct memory _purchaseAgreement
    ) external onlyOwner {
        _drawUpPurchaseAgreement(_purchaseAgreement);
    }
}
