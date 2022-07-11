// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@core/addresser/TruhuisAddresserAPI.sol";
import "@interfaces/IDeedOfDelivery.sol";
import {
    PurchaseAgreementStruct
} from "@interfaces/IPurchaseAgreement.sol";

contract DeedOfDelivery is
    IDeedOfDelivery,
    TruhuisAddresserAPI
{
    mapping(uint256 => DeedOfDeliveryStruct) private _sDeedOfDeliveries;

    uint256 private _sDeedOfDeliveryIds;

    function _drawUpDeedOfDelivery(uint256 _purchaseAgreementId, uint256 _txId)
        internal
    {
        /* ARRANGE */

        PurchaseAgreementStruct memory _purchaseAgreement = notary()
            .getPurchaseAgreement(_purchaseAgreementId);

        // Get buyer account.
        address buyer = _purchaseAgreement.identity.buyer.account;

        // Get seller account.
        address seller = _purchaseAgreement.identity.seller.account;

        // Get token ID.
        uint256 tokenId = _purchaseAgreement
            .sellAndPurchase
            .immovableProperty
            .tokenId;

        // Get available deed of delivery ID.
        uint256 id = _sDeedOfDeliveryIds;

        /* PERFORM ASSERTIONS */

        _validateDeedOfDelivery(_purchaseAgreement);

        /* DRAW UP DEED OF DELIVERY */

        // Confirm transfer.
        cadastre().confirmTransfer(tokenId, _txId);

        // Transfer NFT ownership to the buyer.
        cadastre().transferNFTOwnership(seller, buyer, "", tokenId, _txId);

        DeedOfDeliveryStruct memory deedOfDelivery = DeedOfDeliveryStruct({
            isFulfilled: true,
            deedOfDeliveryId: id,
            purchaseAgreementId: _purchaseAgreement.id,
            tokenId: tokenId,
            transactionId: _txId
        });

        // Unlock NFT payment.
        bank().unlockProceeds(_purchaseAgreement.id);

        _sDeedOfDeliveries[id] = deedOfDelivery;

        _sDeedOfDeliveryIds++;
    }

    function _validateDeedOfDelivery(
        PurchaseAgreementStruct memory _purchaseAgreement
    ) private view {
        /* ARRANGE */

        // Get whether purchase is cancelled.
        bool isPurchaseCancelled = _purchaseAgreement
            .sellAndPurchase
            .immovableProperty
            .isPurchaseCancelled;

        // Get whether payment is fulfilled or not.
        bool isPaymentFulfilled = _purchaseAgreement.payment.isFulfilled;

        // Get whether resolutive conditions dissolved.
        bool isStructuralInspectionDissolved = _purchaseAgreement
            .resolutiveConditions
            .structuralInspection
            .isDissolved;
        bool isFinancingArrangingDissolved = _purchaseAgreement
            .resolutiveConditions
            .financingArranging
            .isDissolved;

        // Get cooling off period.
        uint256 coolingOffPeriod = _purchaseAgreement.coolingOffPeriod.endTime;

        /* PERFORM ASSERTIONS */

        // Purchase agreement must be still valid.
        if (isPurchaseCancelled) {
            revert INVALID_PURCHASE_AGREEMENT();
        }

        // All costs must be paid into notary.
        if (!isPaymentFulfilled) {
            revert PAYMENT_NOT_FULFILLED();
        }

        // Resolutive conditions must be dissolved.
        if (
            !isFinancingArrangingDissolved && !isStructuralInspectionDissolved
        ) {
            revert RESOLUTIVE_CONDITIONS_NOT_DISSOLVED();
        }

        // Cooling-off period must be expired.
        if (coolingOffPeriod > block.timestamp) {
            revert COOLING_OFF_PERIOD_NOT_EXPIRED();
        }
    }
}
