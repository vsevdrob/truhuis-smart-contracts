// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./AbstractMultiSig.sol";

/**
 * @title MultiSig
 * @author vsevdrob
 */
contract MultiSig is AbstractMultiSig {
    /// @dev Token ID => Transaction ID => Account => Whether confirmed or not.
    mapping(uint256 => mapping(uint256 => mapping(address => bool)))
        private _sIsConfirmed;
    /// @dev Token ID => Transaction ID => Transaction struct.
    mapping(uint256 => mapping(uint256 => Transaction)) private _sTransactions;

    /// @dev Required amount of times to confirm a transaction.
    uint256 private constant _S_TIMES_TO_CONFIRM = 2;

    /// @dev A current transaction ID counter.
    uint256 private _sTransactionIdCounter;

    /// @inheritdoc AbstractMultiSig
    function _confirmTransaction(uint256 _tokenId, uint256 _txId)
        internal
        override
    {
        /* ARRANGE */

        // Get transaction.
        Transaction storage sTransaction = _sTransactions[_tokenId][_txId];

        /* PERFORM ASSERTIONS */

        // Transaction must be submitted.
        if (!sTransaction.exists) {
            revert TransactionNotExists(_tokenId, _txId);
        }

        // Transaction must be not executed.
        if (sTransaction.isExecuted) {
            revert TransactionAlreadyExecuted(_tokenId, _txId);
        }

        // Transaction must be not already confirmed.
        if (_sIsConfirmed[_tokenId][_txId][msg.sender]) {
            revert TransactionAlreadyConfirmed(_tokenId, _txId);
        }

        /* CONFIRM TRANSACTION */

        _sIsConfirmed[_tokenId][_txId][msg.sender] = true;
        sTransaction.timesConfirmed += 1;

        // Emit a {TransactionConfirmed} event.
        emit TransactionConfirmed(msg.sender, _tokenId, _txId);
    }

    /// @inheritdoc AbstractMultiSig
    function _deleteTransaction(uint256 _tokenId, uint256 _txId)
        internal
        override
    {
        delete _sTransactions[_tokenId][_txId];
    }

    /// @inheritdoc AbstractMultiSig
    function _revokeConfirmation(uint256 _tokenId, uint256 _txId)
        internal
        override
    {
        /* ARRANGE */

        // Get transaction.
        Transaction storage sTransaction = _sTransactions[_tokenId][_txId];

        /* PERFORM ASSERTIONS */

        // Transaction must be submitted.
        if (!sTransaction.exists) {
            revert TransactionNotExists(_tokenId, _txId);
        }

        // Transaction must be not executed.
        if (sTransaction.isExecuted) {
            revert TransactionAlreadyExecuted(_tokenId, _txId);
        }

        // Transaction must be confirmed.
        if (!_sIsConfirmed[_tokenId][_txId][msg.sender]) {
            revert TransactionNotConfirmed(_tokenId, _txId);
        }

        /* REVOKE CONFIRMATION */

        _sIsConfirmed[_tokenId][_txId][msg.sender] = false;
        sTransaction.timesConfirmed -= 1;

        // Emit an {ConfirmationRevoked} event.
        emit ConfirmationRevoked(msg.sender, _tokenId, _txId);
    }

    /// @inheritdoc AbstractMultiSig
    function _setIsExecuted(uint256 _tokenId, uint256 _txId) internal override {
        _sTransactions[_tokenId][_txId].isExecuted = true;
    }

    /// @inheritdoc AbstractMultiSig
    function _submitTransaction(uint256 _tokenId) internal override {
        /* ARRANGE */

        // Get available transaction ID.
        uint256 txId = _sTransactionIdCounter;

        /* SUBMIT TRANSACTION */

        _sTransactions[_tokenId][txId] = Transaction({
            exists: true,
            isExecuted: false,
            timesConfirmed: 0
        });

        _sTransactionIdCounter++;

        // Emit an {TransactionSubmitted} event.
        emit TransactionSubmitted(msg.sender, _tokenId, txId);
    }

    /// @inheritdoc AbstractMultiSig
    function _validateTransaction(uint256 _tokenId, uint256 _txId)
        internal
        override
    {
        /* ARRANGE */

        // Get transaction.
        Transaction memory transaction = _sTransactions[_tokenId][_txId];

        /* PERFORM ASSERTIONS */

        // Transaction must be not already executed.
        if (transaction.isExecuted) {
            revert TransactionAlreadyExecuted(_tokenId, _txId);
        }

        // There must be enough amount of required confirmations.
        if (transaction.timesConfirmed != _S_TIMES_TO_CONFIRM) {
            revert NotEnoughConfirmations(_tokenId, _txId);
        }
    }
}
