// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

/**
 * @title Signable
 * @author vsevdrob
 * @notice Used by: Personal Records Database
 */
contract Signable {
    error INVALID_CALLER();
    error TRANSACTION_ALREADY_EXECUTED(uint256 txId);
    error TRANSACTION_ALREADY_CONFIRMED(uint256 txId);
    error TRANSACTION_INSUFFICIENTLY_CONFIRMED(uint256 txId);
    error TRANSACTION_NOT_CONFIRMED(uint256 txId);
    error TRANSACTION_NOT_EXISTS(uint256 txId);
    error TRANSACTION_SUFFICIENTLY_CONFIRMED(uint256 txId);

    struct Transaction {
        address[1] confirmers;
        bool exists;
        bool isExecuted;
        uint8 timesConfirmed;
    }

    mapping(uint256 => mapping(address => bool)) private _sIsConfirmed;
    mapping(uint256 => Transaction) private _sTransactions;

    uint256 private _sTxIds = 1;

    event TransactionSubmitted(address caller, uint256 txId);
    event TransactionConfirmed(address caller, uint256 txId);
    event TransactionExecuted(address caller, uint256 txId);
    event ConfirmationRevoked(address caller, uint256 txId);

    /**
     * @dev _
     */
    function getTxIds() public view virtual returns (uint256) {
        return _sTxIds;
    }

    /**
     * @dev _
     */
    function _getTransaction(uint256 _txId)
        public
        view
        virtual
        returns (Transaction memory)
    {
        return _sTransactions[_txId];
    }

    /**
     * @dev _
     */
    function _confirmTransaction(uint256 _txId) internal virtual {
        /* ARRANGE */

        // Get transaction.
        Transaction storage sTransaction = _sTransactions[_txId];

        /* PERFORM ASSERTIONS */

        // Transaction must be submitted.
        if (!sTransaction.exists) {
            revert TRANSACTION_NOT_EXISTS(_txId);
        }

        // Transaction must be confirmed by confirmer.
        if (sTransaction.confirmers[0] != msg.sender) {
            revert INVALID_CALLER();
        }

        // Transaction must be not executed.
        if (sTransaction.isExecuted) {
            revert TRANSACTION_ALREADY_EXECUTED(_txId);
        }

        // Transaction must be not already sufficiently times confirmed.
        if (sTransaction.timesConfirmed == 1) {
            revert TRANSACTION_SUFFICIENTLY_CONFIRMED(_txId);
        }

        // Transaction must be not already confirmed.
        if (_sIsConfirmed[_txId][msg.sender]) {
            revert TRANSACTION_ALREADY_CONFIRMED(_txId);
        }

        /* CONFIRM TRANSACTION */

        sTransaction.timesConfirmed += 1;
        _sIsConfirmed[_txId][msg.sender] = true;

        // Emit a {TransactionConfirmed} event.
        emit TransactionConfirmed(msg.sender, _txId);
    }

    /**
     * @dev _
     */
    function _setIsExecuted(uint256 _txId) internal virtual {
        _sTransactions[_txId].isExecuted = true;
    }

    /**
     * @dev _
     */
    function _submitTransaction(address[1] memory _confirmers) internal virtual {
        /* ARRANGE */

        // Get available transaction ID.
        uint256 txId = _sTxIds;

        /* SUBMIT TRANSACTION */

        _sTransactions[txId] = Transaction({
            confirmers: _confirmers,
            exists: true,
            isExecuted: false,
            timesConfirmed: 0
        });

        _sTxIds++;

        // Emit a {TransactionSubmited} event.
        emit TransactionSubmitted(msg.sender, txId);
    }

    /**
     * @dev _
     */
    function _revokeConfirmation(uint256 _txId) internal virtual {
        /* ARRANGE */

        // Get transaction.
        Transaction storage sTransaction = _sTransactions[_txId];

        /* PERFORM ASSERTIONS */

        // Transaction must be submitted.
        if (!sTransaction.exists) {
            revert TRANSACTION_NOT_EXISTS(_txId);
        }

        // Transaction must be confirmed by confirmer.
        if (sTransaction.confirmers[0] != msg.sender) {
            revert INVALID_CALLER();
        }

        // Transaction must be not executed.
        if (sTransaction.isExecuted) {
            revert TRANSACTION_ALREADY_EXECUTED(_txId);
        }

        // Transaction must be confirmed.
        if (!_sIsConfirmed[_txId][msg.sender]) {
            revert TRANSACTION_NOT_CONFIRMED(_txId);
        }

        /* REVOKE CONFIRMATION */

        _sIsConfirmed[_txId][msg.sender] = false;
        sTransaction.timesConfirmed -= 1;

        // Emit an {ConfirmationRevoked} event.
        emit ConfirmationRevoked(msg.sender, _txId);
    }

    /**
     * @dev _
     */
    function _validateTransaction(uint256 _txId)
        internal
        view
        virtual
    {
        /* ARRANGE */

        // Get transaction.
        Transaction memory transaction = _sTransactions[_txId];

        /* PERFORM ASSERTIONS */

        // Transaction must be submitted.
        if (!transaction.exists) {
            revert TRANSACTION_NOT_EXISTS(_txId);
        }

        // Transaction must be not already executed.
        if (transaction.isExecuted) {
            revert TRANSACTION_ALREADY_EXECUTED(_txId);
        }

        // Transaction must be sufficiently times confirmed.
        if (transaction.timesConfirmed != transaction.confirmers.length) {
            revert TRANSACTION_INSUFFICIENTLY_CONFIRMED(_txId);
        }
    }
}
