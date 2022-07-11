// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {TypeOfGuarantee} from "./IPurchaseAgreement.sol";
import "./ICurrencyRegistry.sol";

error DEPOSIT_DEADLINE_PASSED();
error GUARANTEE_ALREADY_FULFILLED();
error INVALID_CALLER(address caller);
error PAYMENT_ALREADY_FULFILLED();
error PROCEEDS_NOT_LOCKED();
error PURCHASE_AGREEMENT_NOT_EXISTS();
error NO_AVAILABLE_FUNDS();
error NO_PROCEEDS();

/**
 * @dev Debit Debtor 130
 */

struct DebtorBankGuarantee {
    uint256 purchaseAgreementId;
    uint256 approvedAmount;
}

struct DebtorMortgage {
    uint256 mortgageDeedId;
    uint256 approvedAmount;
}

struct Debtor {
    uint256 total;
    DebtorBankGuarantee bankGuarantee;
    DebtorMortgage mortgage;
}

/**
 * @dev Debit Available funds 110
 */

struct AvailableFunds {
    uint256 free;
    uint256 bankGuarantee;
    uint256 mortgage;
}

/**
 * @dev Credit Creditor
 */

struct CreditorDeposit {
    uint256 purchaseAgreementId;
    uint256 amount;
}

struct Creditor {
    uint256 proceeds;
    CreditorDeposit deposit;
}

/**
 * @dev Balance
 */

struct Credit {
    // Account => Currency => Creditor struct.
    mapping(address => mapping(address => Creditor)) creditors;
}

struct Debit {
    // Account => Currency => Debtor struct.
    mapping(address => mapping(address => Debtor)) debtors;
    AvailableFunds availableFunds;
}

struct Balance {
    Debit debit;
    Credit credit;
}

interface ITruhuisBank is ICurrencyRegistry {
    /// @dev _
    event Withdrew(address caller, address currency, uint256 amount);

    /**
     * @dev _
     */
    function fulfillGuarantee(
        uint256 _purchaseAgreementId,
        TypeOfGuarantee _typeOfGuarantee
    ) external;

    /**
     * @dev _
     */
    function fulfillPayment(uint256 _purchaseAgreementId) external;

    /**
     * @dev _
     */
    function takeOutMortgage(uint256 _purchaseAgreementId) external;

    /**
     * @dev _
     */
    function unlockProceeds(uint256 _purchaseAgreementId) external;

    /**
     * @dev _
     */
    function withdrawProceeds(address _currency) external;
}
