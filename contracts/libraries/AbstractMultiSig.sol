// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

abstract contract AbstractMultiSig {
    error TransactionAlreadyExecuted(uint256 tokenId, uint256 txId);
    error TransactionAlreadyConfirmed(uint256 tokenId, uint256 txId);
    error TransactionNotConfirmed(uint256 tokenId, uint256 txId);
    error TransactionNotExists(uint256 tokenId, uint256 txId);
    error NotEnoughConfirmations(uint256 tokenId, uint256 txId);

    struct Transaction {
        bool exists;
        bool isExecuted;
        uint256 timesConfirmed;
    }

    event TransactionSubmitted(address caller, uint256 tokenId, uint256 txId);
    event TransactionConfirmed(address caller, uint256 tokenId, uint256 txId);
    event TransactionExecuted(address caller, uint256 tokenId, uint256 txId);
    event ConfirmationRevoked(address caller, uint256 tokenId, uint256 txId);

    /**
     * @dev _
     */
    function _confirmTransaction(uint256 _tokenId, uint256 _txId)
        internal
        virtual;

    /**
     * @dev _
     */
    function _deleteTransaction(uint256 _tokenId, uint256 _txId)
        internal
        virtual;

    /**
     * @dev _
     */
    function _revokeConfirmation(uint256 _tokenId, uint256 _txId)
        internal
        virtual;

    /**
     * @dev _
     */
    function _setIsExecuted(uint256 _tokenId, uint256 _txId) internal virtual;

    /**
     * @dev _
     */
    function _submitTransaction(uint256 _tokenId)
        internal
        virtual;

    /**
     * @dev _
     */
    function _validateTransaction(uint256 _tokenId, uint256 _txId)
        internal
        virtual;
}
