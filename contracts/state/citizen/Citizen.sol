// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "../utils/MultiSig.sol";

contract Citizen is MultiSig {
    struct Name {
        bytes32 first;
        bytes32 last;
    }

    struct Account {
        address account;
    }

    struct Uri {
        string biometricInfo;
        string photo;
    }

    struct Citizenship {
        bytes3 citizenship;
    }

    struct DateOfBirth {
        uint24 birthtime;
        uint24 day;
        uint24 month;
        uint24 year;
    }

    struct PlaceOfBirth {
        bytes32 city;
        bytes32 state; // or province
        bytes3 country;
    }

    struct SCitizen {
        Name name;
        DateOfBirth dateOfBirth;
        PlaceOfBirth placeOfBirth;
        Account account;
        Uri uri;
        Citizenship citizenship;
    }

    SCitizen public s_citizen;

    constructor(
        bytes32[] memory _name,
        uint24[] memory _dateOfBirth,
        bytes32[] memory _placeOfBirth,
        address[] memory _account,
        string[] memory _uri,
        bytes3[] memory _citizenship
    ) MultiSig(_account[0], msg.sender) {
        s_citizen.name.first = _name[0];
        s_citizen.name.last = _name[1];

        s_citizen.dateOfBirth.birthtime = _dateOfBirth[0];
        s_citizen.dateOfBirth.day = _dateOfBirth[1];
        s_citizen.dateOfBirth.month = _dateOfBirth[2];
        s_citizen.dateOfBirth.year = _dateOfBirth[3];

        s_citizen.placeOfBirth.city = _placeOfBirth[0];
        s_citizen.placeOfBirth.state = _placeOfBirth[1];
        s_citizen.placeOfBirth.country = bytes3(_placeOfBirth[2]);

        s_citizen.account.account = _account[0];

        s_citizen.uri.biometricInfo = _uri[0];
        s_citizen.uri.photo = _uri[1];

        s_citizen.citizenship.citizenship = _citizenship[0];
    }

    function updateFirstName(bytes32 _firstName, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.name.first = _firstName;
        emit TransactionExecuted(msg.sender, _txIndex);
    }

    function updateLastName(bytes32 _lastName, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.name.last = _lastName;
    }

    function updateBirthtime(uint24 _birthtime, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.dateOfBirth.birthtime = _birthtime;
    }

    function updateBirthDay(uint24 _birthDay, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.dateOfBirth.day = _birthDay;
    }

    function updateBirthMonth(uint24 _birthMonth, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.dateOfBirth.month = _birthMonth;
    }

    function updateBirthYear(uint24 _birthYear, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.dateOfBirth.year = _birthYear;
    }

    function updateBirthCity(bytes32 _city, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.placeOfBirth.city = _city;
    }

    function updateBirthState(bytes32 _state, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.placeOfBirth.state = _state;
    }

    function updateBirthCountry(bytes3 _country, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.placeOfBirth.country = _country;
    }

    function updateAccount(address _account, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.account.account = _account;
    }

    function updateBiometricInfoURI(string memory _uri, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.uri.biometricInfo = _uri;
    }

    function updatePhotoURI(string memory _uri, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.uri.photo = _uri;
    }

    function updateCitizenship(bytes32 _citizenship, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_citizen.citizenship.citizenship = bytes3(_citizenship);
    }

    function fullName() public view returns (bytes32, bytes32) {
        return (s_citizen.name.first, s_citizen.name.last);
    }

    function firstName() public view returns (bytes32) {
        return s_citizen.name.first;
    }

    function lastName() public view returns (bytes32) {
        return s_citizen.name.last;
    }

    function birthtime() public view returns (uint24) {
        return s_citizen.dateOfBirth.birthtime;
    }

    function birthDay() public view returns (uint24) {
        return s_citizen.dateOfBirth.day;
    }

    function birthMonth() public view returns (uint24) {
        return s_citizen.dateOfBirth.month;
    }

    function birthYear() public view returns (uint24) {
        return s_citizen.dateOfBirth.year;
    }

    function birthCity() public view returns (bytes32) {
        return s_citizen.placeOfBirth.city;
    }

    function birthState() public view returns (bytes32) {
        return s_citizen.placeOfBirth.state;
    }

    function birthCountry() public view returns (bytes3) {
        return s_citizen.placeOfBirth.country;
    }

    function account() public view returns (address) {
        return s_citizen.account.account;
    }

    function biometricInfoURI() public view returns (string memory) {
        return s_citizen.uri.biometricInfo;
    }

    function photoURI() public view returns (string memory) {
        return s_citizen.uri.photo;
    }

    function citizenship() public view returns (bytes3) {
        return s_citizen.citizenship.citizenship;
    }
}
