// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

contract Signature {
    struct Transaction {
        bool isExecuted;
        uint256 timesConfirmed;
    }

    Transaction[] public transactions;

    mapping(uint256 => mapping(address => bool)) public isConfirmed;

    uint256 public constant TIMES_TO_CONFIRM = 1; // person

    event TransactionSubmited(address caller, uint256 txIndex);
    event TransactionConfirmed(address caller, uint256 txIndex);
    event TransactionExecuted(address caller, uint256 txIndex);
    event RevokeConfirmation(address caller, uint256 txIndex);

    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "tx does not exist");
        _;
    }

    modifier notExecuted(uint256 _txIndex) {
        require(!transactions[_txIndex].isExecuted, "tx already executed");
        _;
    }

    modifier notConfirmed(uint256 _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "tx already confirmed");
        _;
    }

    function submitTransaction() public {
        uint256 txIndex = transactions.length;

        transactions.push(Transaction({isExecuted: false, timesConfirmed: 0}));

        emit TransactionSubmited(msg.sender, txIndex);
    }

    function confirmTransaction(uint256 _txIndex)
        public
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        transaction.timesConfirmed += 1;
        isConfirmed[_txIndex][msg.sender] = true;

        emit TransactionConfirmed(msg.sender, _txIndex);
    }

    function revokeConfirmation(uint256 _txIndex)
        public
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        require(isConfirmed[_txIndex][msg.sender], "tx not confirmed");

        transaction.timesConfirmed -= 1;
        isConfirmed[_txIndex][msg.sender] = false;

        emit RevokeConfirmation(msg.sender, _txIndex);
    }

    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }

    function getTransaction(uint256 _txIndex)
        public
        view
        returns (bool isExecuted, uint256 timesConfirmed)
    {
        Transaction memory transaction = transactions[_txIndex];

        return (transaction.isExecuted, transaction.timesConfirmed);
    }
}
