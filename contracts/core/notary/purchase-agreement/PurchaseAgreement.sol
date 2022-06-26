// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./PurchaseAgreementStorage.sol";
import "../../../interfaces/IPurchaseAgreement.sol";
import "./Article01SellAndPurchase.sol";
import "./Article02Costs.sol";
import "./Article03Payment.sol";
import "./Article04TransferOfOwnership.sol";
import "./Article05BankGuaranteeOrDeposit.sol";
import "./Article14Identity.sol";
import "./Article15ResolutiveConditions.sol";
import "./Article16CoolingOffPeriod.sol";
import "./Article17WrittenRecord.sol";
import "./Article18DutchLaw.sol";

/**
 * @title PurchaseAgreement
 * @author _
 * @notice If you buy or sell an NFT real estate, the agreements are recorded in
 *         a purchase agreement.
 */
contract PurchaseAgreement is
    PurchaseAgreementStorage,
    IPurchaseAgreement,
    Article01SellAndPurchase,
    Article02Costs,
    Article04TransferOfOwnership,
    Article05BankGuaranteeOrDeposit,
    Article14Identity,
    Article15ResolutiveConditions,
    Article16CoolingOffPeriod,
    Article17WrittenRecord,
    Article18DutchLaw
{
    function _drawUpPurchaseAgreement(
        PurchaseAgreementStruct memory _purchaseAgreement
    ) internal {
        uint256 id = _sPurchaseAgreementIds;

        _validatePurchaseAgreement(_purchaseAgreement);
        _sPurchaseAgreements[id] = _purchaseAgreement;

        _sPurchaseAgreementIds++;
    }

    function _validatePurchaseAgreement(
        PurchaseAgreementStruct memory _purchaseAgreement
    ) private {
        // Article 1
        _validateSellAndPurchase(_purchaseAgreement.sellAndPurchase);
        // Article 2
        _validateCosts(_purchaseAgreement.costs);
        // Article 4
        _validateTransferOfOwnership(_purchaseAgreement.transferOfOwnership);
        // Article 5
        _validateBankGuaranteeOrDeposit(
            _purchaseAgreement.sellAndPurchase.immovableProperty.purchasePrice,
            _purchaseAgreement.bankGuaranteeOrDeposit
        );
        // Article 14
        _validateIdentity(
            _purchaseAgreement.sellAndPurchase.immovableProperty.tokenId,
            _purchaseAgreement.identity
        );
        // Article 15
        _validateResolutiveConditions(_purchaseAgreement.resolutiveConditions);
        // Article 16
        _validateCoolingOffPeriod(
            _purchaseAgreement.coolingOffPeriod
        );
        // Article 17
        _validateWrittenRecord(_purchaseAgreement.writtenRecord);
        // Article 18
        _validateDutchLaw(_purchaseAgreement.dutchLaw);
    }
}
