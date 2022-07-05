// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {
    BankGuaranteeOrDeposit__InvalidAmountToApprove,
    BankGuaranteeOrDeposit__InvalidAmountToDeposit,
    BankGuaranteeOrDeposit__InvalidDeadlineToApprove,
    BankGuaranteeOrDeposit__InvalidDeadlineToDeposit,
    BankGuaranteeOrDeposit,
    TypeOfGuarantee
} from "../../../interfaces/IPurchaseAgreement.sol";

contract Article05BankGuaranteeOrDeposit {
    function _validateBankGuaranteeOrDeposit(
        uint256 purchasePrice,
        BankGuaranteeOrDeposit memory _bankGuaranteeOrDeposit
    ) internal view {
        /* ARRANGE */

        // Get type of guarantee.
        TypeOfGuarantee typeOfGuarantee = _bankGuaranteeOrDeposit
            .typeOfGuarantee;

        // Validate bank guarantee.
        if (typeOfGuarantee == TypeOfGuarantee.BANK_GUARANTEE) {
            /* ARRANGE */

            // Get approved amount from bank guarantee.
            uint256 amountToApprove = _bankGuaranteeOrDeposit
                .bankGuarantee
                .amountToApprove;

            // Get deadline to have the disposal of approved bank guarantee.
            uint256 deadlineToApprove = _bankGuaranteeOrDeposit
                .bankGuarantee
                .deadlineToApprove;

            /* PERFORM ASSERTIONS */

            // Amount to approve must be at least 10% of the purchase price.
            if (((purchasePrice / 100) * 10) > amountToApprove) {
                revert BankGuaranteeOrDeposit__InvalidAmountToApprove();
            }

            // Deadline to have the disposal of approved bank guarantee must be
            // greater than current time.
            if (block.timestamp > deadlineToApprove) {
                revert BankGuaranteeOrDeposit__InvalidDeadlineToApprove();
            }
        }

        // Validate deposit.
        if (typeOfGuarantee == TypeOfGuarantee.DEPOSIT) {
            /* ARRANGE */

            // Get amount of to deposit amount.
            uint256 amountToDeposit = _bankGuaranteeOrDeposit.deposit.amountToDeposit;

            // Get deadline to deposit.
            uint256 deadlineToDeposit = _bankGuaranteeOrDeposit
                .deposit
                .deadlineToDeposit;

            /* PERFORM ASSERTIONS */

            // Amount to deposit must be at least 10% of the purchase price.
            if (((purchasePrice / 100) * 10) > amountToDeposit) {
                revert BankGuaranteeOrDeposit__InvalidAmountToDeposit();
            }

            // Deadline to deposit must be greater than current time.
            if (block.timestamp > deadlineToDeposit) {
                revert BankGuaranteeOrDeposit__InvalidDeadlineToDeposit();
            }
        }
    }
}
