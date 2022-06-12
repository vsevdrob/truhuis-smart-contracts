// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../utils/MultiSig.sol";

/*
 * @title Citizen contract. Decentralized digital identity.
 *
 * @dev This contract is deployed by the StateGovernemnt contract only.
 */
contract Resident is MultiSig {

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

    //struct Citizenship {
    //    bytes3 citizenship;
    //}

    //struct Residency {
    //    bytes3 residency;
    //}

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

    struct Resident {
        Name name;
        DateOfBirth dateOfBirth;
        PlaceOfBirth placeOfBirth;
        Account account;
        Uri uri;
        bytes3[] residencies;
        bytes3[] citizenships;
        uint256 residentialNftId;
    }

    Resident public s_resident;

    constructor(
        bytes32[] memory _name,
        uint24[] memory _dateOfBirth,
        bytes32[] memory _placeOfBirth,
        address[] memory _account,
        string[] memory _uri,
        bytes3[] memory _residencies,
        bytes3[] memory _citizenships,
        uint256 _residentialNftId
    ) MultiSig(_account[0], msg.sender) {
        s_resident.name.first = _name[0];
        s_resident.name.last = _name[1];

        s_resident.dateOfBirth.birthtime = _dateOfBirth[0];
        s_resident.dateOfBirth.day = _dateOfBirth[1];
        s_resident.dateOfBirth.month = _dateOfBirth[2];
        s_resident.dateOfBirth.year = _dateOfBirth[3];

        s_resident.placeOfBirth.city = _placeOfBirth[0];
        s_resident.placeOfBirth.state = _placeOfBirth[1];
        s_resident.placeOfBirth.country = bytes3(_placeOfBirth[2]);

        s_resident.account.account = _account[0];

        s_resident.uri.biometricInfo = _uri[0];
        s_resident.uri.photo = _uri[1];

        s_resident.residentialNftId = _residentialNftId;

        for (uint256 i = 0; _citizenships.length > i; i++) {
            s_resident.citizenships.push(_citizenships[i]);
        }
        
        for (uint256 i = 0; _residencies.length > i; i++) {
            s_resident.residencies.push(_residencies[i]);
        }
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

        s_resident.name.first = _firstName;
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

        s_resident.name.last = _lastName;
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

        s_resident.dateOfBirth.birthtime = _birthtime;
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

        s_resident.dateOfBirth.day = _birthDay;
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

        s_resident.dateOfBirth.month = _birthMonth;
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

        s_resident.dateOfBirth.year = _birthYear;
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

        s_resident.placeOfBirth.city = _city;
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

        s_resident.placeOfBirth.state = _state;
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

        s_resident.placeOfBirth.country = _country;
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

        s_resident.account.account = _account;
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

        s_resident.uri.biometricInfo = _uri;
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

        s_resident.uri.photo = _uri;
    }

    function addResidency(bytes3 _residency, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_resident.residencies.push(_residency);
    }

    function deleteResidency(bytes3 _residency, uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage s_transaction = transactions[_txIndex];
        require(s_transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        s_transaction.isExecuted = true;

        for (uint256 i = 0; s_resident.residencies.length > i; i++) {
            if (_residency == s_resident.residencies[i]) {
                delete s_resident.residencies[i];
            }
        }
    }

    function addCitizenship(bytes3 _citizenship, uint256 _txIndex)
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        transaction.isExecuted = true;

        s_resident.citizenships.push(_citizenship);
    }

    function deleteCitizenship(bytes3 _citizenship, uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage s_transaction = transactions[_txIndex];
        require(s_transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
        s_transaction.isExecuted = true;

        for (uint256 i = 0; s_resident.citizenships.length > i; i++) {
            if (_citizenship == s_resident.citizenships[i]) {
                delete s_resident.citizenships[i];
            }
        }
    }

    function fullName() public view returns (bytes32, bytes32) {
        return (s_resident.name.first, s_resident.name.last);
    }

    function firstName() public view returns (bytes32) {
        return s_resident.name.first;
    }

    function lastName() public view returns (bytes32) {
        return s_resident.name.last;
    }

    function birthtime() public view returns (uint24) {
        return s_resident.dateOfBirth.birthtime;
    }

    function birthDay() public view returns (uint24) {
        return s_resident.dateOfBirth.day;
    }

    function birthMonth() public view returns (uint24) {
        return s_resident.dateOfBirth.month;
    }

    function birthYear() public view returns (uint24) {
        return s_resident.dateOfBirth.year;
    }

    function birthCity() public view returns (bytes32) {
        return s_resident.placeOfBirth.city;
    }

    function birthState() public view returns (bytes32) {
        return s_resident.placeOfBirth.state;
    }

    function birthCountry() public view returns (bytes3) {
        return s_resident.placeOfBirth.country;
    }

    function account() public view returns (address) {
        return s_resident.account.account;
    }

    function biometricInfoURI() public view returns (string memory) {
        return s_resident.uri.biometricInfo;
    }

    function photoURI() public view returns (string memory) {
        return s_resident.uri.photo;
    }

    function citizenships() public view returns (bytes3[] memory) {
        return s_resident.citizenships;
    }

    function residencies() public view returns (bytes3[] memory) {
        return s_resident.residencies;
    }

    function isCitizenOf(bytes3 _country) public view returns (bool) {
        for (uint256 i = 0; s_resident.citizenships.length > i; i++) {
            if (_country == s_resident.citizenships[i]) {
                return true;
            }
        }

        return false;
    }

    function isResidentOf(bytes3 _country) public view returns (bool) {
        for (uint256 i = 0; s_resident.residencies.length > i; i++) {
            if (_country == s_resident.residencies[i]) {
                return true;
            }
        }

        return false;
    }

    function isAllowedToPurchaseRealEstate(bytes3 _country) public view returns (bool) {
        for (uint256 i = 0; s_resident.citizenships.length > i; i++) {
            if (_country == s_resident.citizenships[i]) {
                return true;
            }
        }

        return false;
    }

    function residentialNftId() external view returns (uint256) {
        return s_resident.residentialNftId;
    }
}
