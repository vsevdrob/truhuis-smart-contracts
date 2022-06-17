// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../../libraries/Signature.sol";
import "../../interfaces/IPersonalRecordsDatabase.sol";
import "../address/TruhuisAddressRegistryAdapter.sol";
import {
    PersonalRecordsDatabaseStorage as Storage
} from "./PersonalRecordsDatabaseStorage.sol";

error MunicipalityIsNotRegistered();
error InvalidPersonResidency(
    uint16 residencyMunicipalityCBSCode,
    uint16 municipalityCBSCode
);

/*
 * @title PersonalRecordsDatabase
 */
contract PersonalRecordsDatabase is
    Signature,
    IPersonalRecordsDatabase,
    Storage,
    TruhuisAddressRegistryAdapter
{
    modifier onlyMunicipality(address _person, uint16 _cbsCode) {
        bool isRegistered = addressRegistry().isRegisteredMunicipality(
            msg.sender,
            _cbsCode
        );

        if (!isRegistered) {
            revert MunicipalityIsNotRegistered();
        }

        uint16 cbsCode = _sPersonalRecords[_person].currentAddress.municipality;

        if (cbsCode != _cbsCode) {
            revert InvalidPersonResidency(cbsCode, _cbsCode);
        }

        _;
    }

    function storePersonalRecords(
        PersonalRecords calldata _parameters,
        address _person,
        uint16 _cbsCode,
        uint256 _txIndex
    )
        external
        onlyMunicipality(_person, _cbsCode)
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        _sPersonalRecords[_parameters.account] = _parameters;
    }

    function retrievePersonalRecords(address _person)
        external
        view
        returns (PersonalRecords memory)
    {
        return _sPersonalRecords[_person];
    }

    function updateFirstName(
        address _person,
        bytes32 _firstName,
        uint16 _cbsCode,
        uint256 _txIndex
    )
        public
        onlyMunicipality(_person, _cbsCode)
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(
            transaction.timesConfirmed >= TIMES_TO_CONFIRM,
            "cannot execute tx"
        );
        transaction.isExecuted = true;

        _sPersonalRecords[_person].name.first = _firstName;
        emit TransactionExecuted(msg.sender, _txIndex);
    }

    function updateLastName(
        address _person,
        bytes32 _lastName,
        uint16 _cbsCode,
        uint256 _txIndex
    )
        public
        onlyMunicipality(_person, _cbsCode)
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(
            transaction.timesConfirmed >= TIMES_TO_CONFIRM,
            "cannot execute tx"
        );
        transaction.isExecuted = true;

        _sPersonalRecords[_person].name.last = _lastName;
    }

    function updateBirthDay(
        address _person,
        uint24 _birthDay,
        uint16 _cbsCode,
        uint256 _txIndex
    )
        public
        onlyMunicipality(_person, _cbsCode)
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(
            transaction.timesConfirmed >= TIMES_TO_CONFIRM,
            "cannot execute tx"
        );
        transaction.isExecuted = true;

        _sPersonalRecords[_person].dateOfBirth.day = _birthDay;
    }

    function updateBirthMonth(
        address _person,
        uint24 _birthMonth,
        uint16 _cbsCode,
        uint256 _txIndex
    )
        public
        onlyMunicipality(_person, _cbsCode)
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(
            transaction.timesConfirmed >= TIMES_TO_CONFIRM,
            "cannot execute tx"
        );
        transaction.isExecuted = true;

        _sPersonalRecords[_person].dateOfBirth.month = _birthMonth;
    }

    function updateBirthYear(
        address _person,
        uint24 _birthYear,
        uint16 _cbsCode,
        uint256 _txIndex
    )
        public
        onlyMunicipality(_person, _cbsCode)
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(
            transaction.timesConfirmed >= TIMES_TO_CONFIRM,
            "cannot execute tx"
        );
        transaction.isExecuted = true;

        _sPersonalRecords[_person].dateOfBirth.year = _birthYear;
    }

    function updateBirthCity(
        address _person,
        bytes32 _city,
        uint16 _cbsCode,
        uint256 _txIndex
    )
        public
        onlyMunicipality(_person, _cbsCode)
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(
            transaction.timesConfirmed >= TIMES_TO_CONFIRM,
            "cannot execute tx"
        );
        transaction.isExecuted = true;

        _sPersonalRecords[_person].placeOfBirth.city = _city;
    }

    function updateBirthProvince(
        address _person,
        bytes32 _province,
        uint16 _cbsCode,
        uint256 _txIndex
    )
        public
        onlyMunicipality(_person, _cbsCode)
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(
            transaction.timesConfirmed >= TIMES_TO_CONFIRM,
            "cannot execute tx"
        );
        transaction.isExecuted = true;

        _sPersonalRecords[_person].placeOfBirth.province = _province;
    }

    function updateBirthCountry(
        address _person,
        bytes3 _country,
        uint16 _cbsCode,
        uint256 _txIndex
    )
        public
        onlyMunicipality(_person, _cbsCode)
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(
            transaction.timesConfirmed >= TIMES_TO_CONFIRM,
            "cannot execute tx"
        );
        transaction.isExecuted = true;

        _sPersonalRecords[_person].placeOfBirth.country = _country;
    }

    //function updateAccount(
    //    address _prevAccount, address _account, uint16 _cbsCode, uint256 _txIndex
    //)
    //    public
    //    onlyMunicipality(_prevAccount, _cbsCode)
    //    txExists(_txIndex)
    //    notExecuted(_txIndex)
    //{
    //    Transaction storage transaction = transactions[_txIndex];
    //    require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
    //    transaction.isExecuted = true;

    //    _sPersonalRecords[_prevAccount].account = _account;
    //}

    //function addResidency(bytes3 _residency, uint256 _txIndex)
    //    public
    //    onlyOwner
    //    txExists(_txIndex)
    //    notExecuted(_txIndex)
    //{
    //    Transaction storage transaction = transactions[_txIndex];
    //    require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
    //    transaction.isExecuted = true;

    //    _sPersonalRecords.residencies.push(_residency);
    //}

    //function deleteResidency(bytes3 _residency, uint256 _txIndex)
    //    public
    //    onlyOwner
    //    txExists(_txIndex)
    //    notExecuted(_txIndex)
    //{
    //    Transaction storage s_transaction = transactions[_txIndex];
    //    require(s_transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
    //    s_transaction.isExecuted = true;

    //    for (uint256 i = 0; _sPersonalRecords.residencies.length > i; i++) {
    //        if (_residency == _sPersonalRecords.residencies[i]) {
    //            delete _sPersonalRecords.residencies[i];
    //        }
    //    }
    //}

    //function addCitizenship(bytes3 _citizenship, uint256 _txIndex)
    //    public
    //    onlyOwner
    //    txExists(_txIndex)
    //    notExecuted(_txIndex)
    //{
    //    Transaction storage transaction = transactions[_txIndex];
    //    require(transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
    //    transaction.isExecuted = true;

    //    _sPersonalRecords.citizenships.push(_citizenship);
    //}

    //function deleteCitizenship(bytes3 _citizenship, uint256 _txIndex)
    //    public
    //    onlyOwner
    //    txExists(_txIndex)
    //    notExecuted(_txIndex)
    //{
    //    Transaction storage s_transaction = transactions[_txIndex];
    //    require(s_transaction.timesConfirmed >= TIMES_TO_CONFIRM, "cannot execute tx");
    //    s_transaction.isExecuted = true;

    //    for (uint256 i = 0; _sPersonalRecords.citizenships.length > i; i++) {
    //        if (_citizenship == _sPersonalRecords.citizenships[i]) {
    //            delete _sPersonalRecords.citizenships[i];
    //        }
    //    }
    //}

    function fullName(address _person) public view returns (bytes32, bytes32) {
        return (
            _sPersonalRecords[_person].name.first,
            _sPersonalRecords[_person].name.last
        );
    }

    function firstName(address _person) public view returns (bytes32) {
        return _sPersonalRecords[_person].name.first;
    }

    function lastName(address _person) public view returns (bytes32) {
        return _sPersonalRecords[_person].name.last;
    }

    function birthDay(address _person) public view returns (uint24) {
        return _sPersonalRecords[_person].dateOfBirth.day;
    }

    function birthMonth(address _person) public view returns (uint24) {
        return _sPersonalRecords[_person].dateOfBirth.month;
    }

    function birthYear(address _person) public view returns (uint24) {
        return _sPersonalRecords[_person].dateOfBirth.year;
    }

    function birthCity(address _person) public view returns (bytes32) {
        return _sPersonalRecords[_person].placeOfBirth.city;
    }

    function birthProvince(address _person) public view returns (bytes32) {
        return _sPersonalRecords[_person].placeOfBirth.province;
    }

    function birthCountry(address _person) public view returns (bytes3) {
        return _sPersonalRecords[_person].placeOfBirth.country;
    }

    function account(address _person) public view returns (address) {
        return _sPersonalRecords[_person].account;
    }

    function residency(address _person) public view returns (Residency) {
        return _sPersonalRecords[_person].residency;
    }

    function isDutchNationality(address _person) public view returns (bool) {
        return
            _sPersonalRecords[_person].residency == Residency.DUTCH_NATIONALITY;
    }

    //function citizenships() public view returns (bytes3[] memory) {
    //    return _sPersonalRecords.citizenships;
    //}

    //function residencies() public view returns (bytes3[] memory) {
    //    return _sPersonalRecords.residencies;
    //}

    //function isCitizenOf(bytes3 _country) public view returns (bool) {
    //    for (uint256 i = 0; _sPersonalRecords.citizenships.length > i; i++) {
    //        if (_country == _sPersonalRecords.citizenships[i]) {
    //            return true;
    //        }
    //    }

    //    return false;
    //}

    //function isResidentOf(bytes3 _country) public view returns (bool) {
    //    for (uint256 i = 0; _sPersonalRecords.residencies.length > i; i++) {
    //        if (_country == _sPersonalRecords.residencies[i]) {
    //            return true;
    //        }
    //    }

    //    return false;
    //}

    //function isAllowedToPurchaseRealEstate(bytes3 _country) public view returns (bool) {
    //    for (uint256 i = 0; _sPersonalRecords.citizenships.length > i; i++) {
    //        if (_country == _sPersonalRecords.citizenships[i]) {
    //            return true;
    //        }
    //    }

    //    return false;
    //}

    //function residentialNftId() external view returns (uint256) {
    //    return _sPersonalRecords.residentialNftId;
    //}
}
