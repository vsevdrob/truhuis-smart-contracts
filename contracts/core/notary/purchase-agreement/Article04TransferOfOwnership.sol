// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {
    TransferOfOwnership__InvalidDateOfLegalTransfer,
    TransferOfOwnership__InvalidDateOfActualTransfer,
    TransferOfOwnership
} from "../../../interfaces/IPurchaseAgreement.sol";

contract Article04TransferOfOwnership {
    function _validateTransferOfOwnership(
        TransferOfOwnership memory _transferOfOwnership
    ) internal view {
        /* ARRANGE */

        // Get date of actual transfer.
        uint256 dateOfActualTransfer = _transferOfOwnership
            .dateOfActualTransfer;

        // Get date of legal transfer.
        uint256 dateOfLegalTransfer = _transferOfOwnership.dateOfLegalTransfer;

        /* PERFORM ASSERTIONS */

        // Date of actual transfer must be greater than current time.
        if (block.timestamp > dateOfActualTransfer) {
            revert TransferOfOwnership__InvalidDateOfActualTransfer();
        }

        // Date of legal transfer must be greater than current time.
        if (block.timestamp > dateOfLegalTransfer) {
            revert TransferOfOwnership__InvalidDateOfLegalTransfer();
        }
    }
}
