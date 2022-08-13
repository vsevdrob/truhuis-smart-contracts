// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

/**
 * @title MultiSignable
 * @author vsevdrob
 * @notice Used by: Truhuis Cadastre
 */
contract MultiSignable {
    error INVALID_CALLER();
    error TRANSACTION_ALREADY_EXECUTED(uint256 tokenId, uint256 txId);
    error TRANSACTION_ALREADY_CONFIRMED(uint256 tokenId, uint256 txId);
    error TRANSACTION_INSUFFICIENTLY_CONFIRMED(uint256 tokenId, uint256 txId);
    error TRANSACTION_NOT_CONFIRMED(uint256 tokenId, uint256 txId);
    error TRANSACTION_NOT_EXISTS(uint256 tokenId, uint256 txId);
    error TRANSACTION_SUFFICIENTLY_CONFIRMED(uint256 tokenId, uint256 txId);

    struct Transaction {
        address[3] confirmers;
        bool exists;
        bool isExecuted;
        uint8 timesConfirmed;
    }

    /// @dev Token ID => Transaction ID => Account => Whether confirmed or not.
    mapping(uint256 => mapping(uint256 => mapping(address => bool)))
        private _sIsConfirmed;
    /// @dev Token ID => Transaction ID => Transaction struct.
    mapping(uint256 => mapping(uint256 => Transaction)) private _sTransactions;

    /// @dev Required amount of times to confirm a transaction.
    uint256 private constant _S_TIMES_TO_CONFIRM = 2;

    /// @dev A current transaction ID counter.
    uint256 private _sTxIds = 1;

    event TransactionSubmitted(address caller, uint256 tokenId, uint256 txId);
    event TransactionConfirmed(address caller, uint256 tokenId, uint256 txId);
    event TransactionExecuted(address caller, uint256 tokenId, uint256 txId);
    event ConfirmationRevoked(address caller, uint256 tokenId, uint256 txId);

    /**
     * @dev _
     */
    function getTxIds() public view virtual returns (uint256) {
        return _sTxIds;
    }

    /**
     * @dev _
     */
    function _confirmTransaction(uint256 _tokenId, uint256 _txId)
        internal
        virtual
    {
        /* ARRANGE */

        // Get transaction.
        Transaction storage sTransaction = _sTransactions[_tokenId][_txId];

        /* PERFORM ASSERTIONS */

        // Transaction must be submitted.
        if (!sTransaction.exists) {
            revert TRANSACTION_NOT_EXISTS(_tokenId, _txId);
        }

        // Transaction must be confirmed by one of the confirmers.
        for (uint8 i = 0; sTransaction.confirmers.length > i; i++) {
            if (sTransaction.confirmers[i] == msg.sender) {
                break;
            } else if (sTransaction.confirmers.length == i) {
                revert INVALID_CALLER();
            }
        }

        // Transaction must be not executed.
        if (sTransaction.isExecuted) {
            revert TRANSACTION_ALREADY_EXECUTED(_tokenId, _txId);
        }

        // Transaction must be not already sufficiently times confirmed.
        if (sTransaction.timesConfirmed == sTransaction.confirmers.length) {
            revert TRANSACTION_SUFFICIENTLY_CONFIRMED(_tokenId, _txId);
        }

        // Transaction must be not already confirmed.
        if (_sIsConfirmed[_tokenId][_txId][msg.sender]) {
            revert TRANSACTION_ALREADY_CONFIRMED(_tokenId, _txId);
        }

        /* CONFIRM TRANSACTION */

        // TODO: improve and modify the following statement.
        _sIsConfirmed[_tokenId][_txId][msg.sender] = true;
        sTransaction.confirmers[2] == address(0) &&
            sTransaction.timesConfirmed != 2
            ? sTransaction.timesConfirmed += 2
            : sTransaction.timesConfirmed += 1;

        // Emit a {TransactionConfirmed} event.
        emit TransactionConfirmed(msg.sender, _tokenId, _txId);
    }

    /**
     * @dev _
     */
    function _deleteTransaction(uint256 _tokenId, uint256 _txId)
        internal
        virtual
    {
        delete _sTransactions[_tokenId][_txId];
    }

    /**
     * @dev _
     */
    function _revokeConfirmation(uint256 _tokenId, uint256 _txId)
        internal
        virtual
    {
        /* ARRANGE */

        // Get transaction.
        Transaction storage sTransaction = _sTransactions[_tokenId][_txId];

        /* PERFORM ASSERTIONS */

        // Transaction must be submitted.
        if (!sTransaction.exists) {
            revert TRANSACTION_NOT_EXISTS(_tokenId, _txId);
        }

        // Transaction must be confirmed by one of the confirmers.
        if (
            sTransaction.confirmers[0] != msg.sender ||
            sTransaction.confirmers[1] != msg.sender ||
            sTransaction.confirmers[2] != msg.sender
        ) {
            revert INVALID_CALLER();
        }

        // Transaction must be not executed.
        if (sTransaction.isExecuted) {
            revert TRANSACTION_ALREADY_EXECUTED(_tokenId, _txId);
        }

        // Transaction must be confirmed.
        if (!_sIsConfirmed[_tokenId][_txId][msg.sender]) {
            revert TRANSACTION_NOT_CONFIRMED(_tokenId, _txId);
        }

        /* REVOKE CONFIRMATION */

        _sIsConfirmed[_tokenId][_txId][msg.sender] = false;
        sTransaction.confirmers[2] == address(0)
            ? sTransaction.timesConfirmed -= 2
            : sTransaction.timesConfirmed -= 1;

        // Emit an {ConfirmationRevoked} event.
        emit ConfirmationRevoked(msg.sender, _tokenId, _txId);
    }

    /**
     * @dev _
     */
    function _setIsExecuted(uint256 _tokenId, uint256 _txId) internal virtual {
        _sTransactions[_tokenId][_txId].isExecuted = true;
    }

    /**
     * @dev _
     */
    function _submitTransaction(address[3] memory _confirmers, uint256 _tokenId)
        internal
        virtual
    {
        /* ARRANGE */

        // Get available transaction ID.
        uint256 txId = _sTxIds;

        /* SUBMIT TRANSACTION */

        _sTransactions[_tokenId][txId] = Transaction({
            confirmers: _confirmers,
            exists: true,
            isExecuted: false,
            timesConfirmed: 0
        });

        _sTxIds++;

        // Emit a {TransactionSubmitted} event.
        emit TransactionSubmitted(msg.sender, _tokenId, txId);
    }

    /**
     * @dev _
     */
    function _validateTransaction(uint256 _tokenId, uint256 _txId)
        internal
        view
        virtual
    {
        /* ARRANGE */

        // Get transaction.
        Transaction memory transaction = _sTransactions[_tokenId][_txId];

        /* PERFORM ASSERTIONS */

        // Transaction must be submitted.
        if (!transaction.exists) {
            revert TRANSACTION_NOT_EXISTS(_tokenId, _txId);
        }

        // Transaction must be not already executed.
        if (transaction.isExecuted) {
            revert TRANSACTION_ALREADY_EXECUTED(_tokenId, _txId);
        }

        // Transaction must be sufficiently times confirmed.
        if (transaction.timesConfirmed != transaction.confirmers.length) {
            revert TRANSACTION_INSUFFICIENTLY_CONFIRMED(_tokenId, _txId);
        }
    }
}
