// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {
    PurchaseAgreementStruct,
    TypeOfGuarantee
} from "../../interfaces/IPurchaseAgreement.sol";
import "../address/TruhuisAddressRegistryAdapter.sol";
import "../../libraries/TokenTransferrer.sol";
import "../../interfaces/ITruhuisBank.sol";

/**
 * @title ATruhuisBank
 * @author vsevdrob
 * @notice _
 */
abstract contract ATruhuisBank is
    ITruhuisBank,
    TruhuisAddressRegistryAdapter,
    TokenTransferrer
{
    /// @dev Purchase agreement ID => Whether proceeds are locked or not.
    mapping(uint256 => bool) private _sAreProceedsLocked;

    Balance private _sBalance;

    constructor(address _addressRegistry) {
        updateAddressRegistry(_addressRegistry);
    }

    function _fulfillGuarantee(
        uint256 _purchaseAgreementId,
        TypeOfGuarantee _typeOfGuarantee
    ) internal {
        /* ARRANGE */

        // Get purchase agreement.
        PurchaseAgreementStruct memory purchaseAgreement = notary()
            .getPurchaseAgreement(_purchaseAgreementId);

        // Get buyer.
        address buyer = purchaseAgreement.identity.buyer.account;

        // Get currency.
        address currency = purchaseAgreement.payment.currency;

        // Get whether guarantee already fulfilled.
        bool isFulfilled = purchaseAgreement.bankGuaranteeOrDeposit.isFulfilled;

        /* PERFORM ASSERTIONS */

        // Caller must be the buyer.
        if (msg.sender != buyer) {
            revert INVALID_CALLER(msg.sender);
        }

        // Guarantee must be not already fulfilled.
        if (isFulfilled) {
            revert GUARANTEE_ALREADY_FULFILLED();
        }

        // Type of buyer's guarantee is deposit.
        if (_typeOfGuarantee == TypeOfGuarantee.DEPOSIT) {
            /* ARRANGE */

            // Get amount to deposit.
            uint256 amountToDeposit = purchaseAgreement
                .bankGuaranteeOrDeposit
                .deposit
                .amountToDeposit;

            // Get deadline to deposit.
            uint256 deadlineToDeposit = purchaseAgreement
                .bankGuaranteeOrDeposit
                .deposit
                .deadlineToDeposit;

            // Get deposit.
            CreditorDeposit storage deposit = _sBalance
            .credit
            .creditors[msg.sender][currency].deposit;

            /* PERFORM ASSERTIONS */

            // Deadline must be not already passed.
            if (block.timestamp > deadlineToDeposit) {
                revert DEPOSIT_DEADLINE_PASSED();
            }

            _performERC20TransferFrom(
                msg.sender,
                address(this),
                currency,
                amountToDeposit
            );

            deposit.amount = amountToDeposit;
            deposit.purchaseAgreementId = _purchaseAgreementId;

            notary().setGuaranteeIsProvided(
                _purchaseAgreementId,
                _typeOfGuarantee
            );
        }

        // Type of buyer's guarantee is bank guarantee.
        if (_typeOfGuarantee == TypeOfGuarantee.BANK_GUARANTEE) {
            /* ARRANGE */

            // Get amount to approve.
            uint256 amountToApprove = purchaseAgreement
                .bankGuaranteeOrDeposit
                .bankGuarantee
                .amountToApprove;

            // Get deadline to approve.
            uint256 deadlineToApprove = purchaseAgreement
                .bankGuaranteeOrDeposit
                .bankGuarantee
                .deadlineToApprove;

            // Get available funds.
            uint256 availableFunds = _sBalance
                .debit
                .availableFunds
                .bankGuarantee;

            // Get bank guarantee storage.
            DebtorBankGuarantee storage bankGuarantee = _sBalance
            .debit
            .debtors[msg.sender][currency].bankGuarantee;

            /* PERFORM ASSERTIONS */

            // Deadline must be not already passed.
            if (block.timestamp > deadlineToApprove) {
                revert DEPOSIT_DEADLINE_PASSED();
            }

            // Free balance must be greater than amount to approve.
            if (amountToApprove > availableFunds) {
                revert NO_AVAILABLE_FUNDS();
            }

            /* APPROVE BANK GUARANTEE */

            _sBalance.debit.availableFunds.bankGuarantee -= amountToApprove;

            bankGuarantee.approvedAmount = amountToApprove;
            bankGuarantee.purchaseAgreementId = _purchaseAgreementId;

            notary().setGuaranteeIsProvided(
                _purchaseAgreementId,
                _typeOfGuarantee
            );
        }
    }

    // TODO: undertake modifications if an address has been updated.
    function _fulfillPayment(uint256 _purchaseAgreementId) internal {
        /* ARRANGE */

        // Get purchase agreement.
        PurchaseAgreementStruct memory purchaseAgreement = notary()
            .getPurchaseAgreement(_purchaseAgreementId);

        // Get buyer.
        address buyer = purchaseAgreement.identity.buyer.account;

        // Get currency.
        address currency = purchaseAgreement.payment.currency;

        // Get whether payment is already fulfilled or not.
        bool isPaymentFulfilled = purchaseAgreement.payment.isFulfilled;

        // Get whether purchase agreement is existent or not.
        bool isPurchaseAgreementExistent = purchaseAgreement.exists;

        // Get cadastre costs.
        uint256 cadastreCosts = purchaseAgreement.costs.cadastre.amount;

        // Get trade costs.
        uint256 tradeCosts = purchaseAgreement.costs.trade.amount;

        // Get notary costs.
        uint256 notaryCosts = purchaseAgreement.costs.notary.amount;

        // Get tax administration costs.
        uint256 taxAdministrationCosts = purchaseAgreement
            .costs
            .taxAdministration
            .salesTaxAmount +
            purchaseAgreement.costs.taxAdministration.transferTaxAmount;

        // Get immovable property price.
        uint256 immovablePropertyPrice = purchaseAgreement
            .sellAndPurchase
            .immovableProperty
            .price;

        // Get movable properties price.
        uint256 movablePropertiesPrice = purchaseAgreement
            .sellAndPurchase
            .movableProperties
            .price;

        // Get total amount to pay.
        uint256 totalAmount = cadastreCosts +
            tradeCosts +
            notaryCosts +
            taxAdministrationCosts +
            movablePropertiesPrice +
            immovablePropertyPrice;

        /* PERFORM ASSERTIONS */

        // Purchase agreement must be existent.
        if (!isPurchaseAgreementExistent) {
            revert PURCHASE_AGREEMENT_NOT_EXISTS();
        }

        // Caller must be the buyer.
        if (msg.sender != buyer) {
            revert INVALID_CALLER(msg.sender);
        }

        // Payment must be not already fulfilled.
        if (isPaymentFulfilled) {
            revert PAYMENT_ALREADY_FULFILLED();
        }

        /* FULFILL NFT PAYMENT */

        _performERC20TransferFrom(
            msg.sender,
            address(this),
            currency,
            totalAmount
        );

        _sAreProceedsLocked[_purchaseAgreementId] = true;

        notary().setPaymentIsFulfilled(_purchaseAgreementId);
    }

    /// TODO:
    function _takeOutMortgage(uint256 _purchaseAgreementId) internal {
        notary().setFinancingArrangingIsDissolved(_purchaseAgreementId);
    }

    function _unlockProceeds(uint256 _purchaseAgreementId) internal {
        /* ARRANGE */

        // Get purchase agreement.
        PurchaseAgreementStruct memory purchaseAgreement = notary()
            .getPurchaseAgreement(_purchaseAgreementId);

        // Get currency.
        address currency = purchaseAgreement.payment.currency;

        // Get seller.
        address seller = purchaseAgreement.identity.seller.account;

        // Get whether payment is locked or not.
        bool areProceedsLocked = _sAreProceedsLocked[_purchaseAgreementId];

        // Get cadastre costs.
        uint256 cadastreCosts = purchaseAgreement.costs.cadastre.amount;

        // Get trade3 costs.
        uint256 tradeCosts = purchaseAgreement.costs.trade.amount;

        // Get notary costs.
        uint256 notaryCosts = purchaseAgreement.costs.notary.amount;

        // Get tax administration costs.
        uint256 taxAdministrationCosts = purchaseAgreement
            .costs
            .taxAdministration
            .salesTaxAmount +
            purchaseAgreement.costs.taxAdministration.transferTaxAmount;

        // Get immovable property price.
        uint256 immovablePropertyPrice = purchaseAgreement
            .sellAndPurchase
            .immovableProperty
            .price;

        // Get movable properties price.
        uint256 movablePropertiesPrice = purchaseAgreement
            .sellAndPurchase
            .movableProperties
            .price;

        /* PERFORM ASSERTIONS */

        // Caller must be the notary.
        if (msg.sender != address(notary())) {
            revert INVALID_CALLER(msg.sender);
        }

        // Payment must be locked.
        if (!areProceedsLocked) {
            revert PROCEEDS_NOT_LOCKED();
        }

        /* UNLOCK PROCEEDS */

        _unlockProceeds(
            currency,
            seller,
            cadastreCosts,
            tradeCosts,
            notaryCosts,
            taxAdministrationCosts,
            immovablePropertyPrice + movablePropertiesPrice
        );

        _sAreProceedsLocked[_purchaseAgreementId] = false;
    }

    function _withdrawProceeds(address _currency) internal {
        /* ARRANGE */

        // Get amount.
        uint256 proceeds = _sBalance
        .credit
        .creditors[msg.sender][_currency].proceeds;

        /* PERFORM ASSERTIONS */

        // Amount must be greater than zero.
        if (0 >= proceeds) {
            revert NO_PROCEEDS();
        }

        /* WITHDRAW */

        _sBalance.credit.creditors[msg.sender][_currency].proceeds = 0;
        _performERC20Transfer(msg.sender, _currency, proceeds);

        // Emit a {Withdrew} event.
        emit Withdrew(msg.sender, _currency, proceeds);
    }

    function _unlockProceeds(
        address _currency,
        address _seller,
        uint256 _cadastreProceeds,
        uint256 _tradeProceeds,
        uint256 _notaryProceeds,
        uint256 _taxAdministrationProceeds,
        uint256 _sellerProceeds
    ) private {
        /* ARRANGE */

        Creditor storage creditorCadastre = _sBalance.credit.creditors[
            address(cadastre())
        ][_currency];
        Creditor storage creditorTrade = _sBalance.credit.creditors[
            address(trade())
        ][_currency];
        Creditor storage creditorNotary = _sBalance.credit.creditors[
            address(notary())
        ][_currency];
        Creditor storage creditorTaxAdministration = _sBalance.credit.creditors[
            address(taxAdministration())
        ][_currency];
        Creditor storage creditorSeller = _sBalance.credit.creditors[
            address(_seller)
        ][_currency];

        /* UNLOCK PROCEEDS */

        creditorCadastre.proceeds += _cadastreProceeds;
        creditorTrade.proceeds += _tradeProceeds;
        creditorNotary.proceeds += _notaryProceeds;
        creditorTaxAdministration.proceeds += _taxAdministrationProceeds;
        creditorSeller.proceeds += _sellerProceeds;
    }
}
