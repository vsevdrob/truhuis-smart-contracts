// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../../libraries/Signable.sol";
import "../../interfaces/IPersonalRecordsDatabase.sol";
import "../address/TruhuisAddressRegistryAdapter.sol";

/*
 * @title PersonalRecordsDatabase
 * @author vsevdrob
 * @notice _
 */
contract PersonalRecordsDatabase is
    Signable,
    IPersonalRecordsDatabase,
    TruhuisAddressRegistryAdapter
{
    mapping(address => PersonalRecords) internal _sPersonalRecords;

    modifier onlyMunicipality(bytes4 _cbsCode) {
        /* ARRANGE */

        bool isRegistered = addressRegistry().isRegisteredMunicipality(
            msg.sender,
            _cbsCode
        );

        /* PERFORM ASSERTIONS */

        if (!isRegistered) {
            revert MUNICIPALITY_NOT_REGISTERED();
        }

        _;
    }

    constructor(address _addressRegistry) {
        updateAddressRegistry(_addressRegistry);
    }

    function confirmRequest(uint256 _txId) external {
        _confirmTransaction(_txId);
    }

    function submitRequest(address[1] memory _confirmers) external {
        _submitTransaction(_confirmers);
    }

    function storePersonalRecords(
        PersonalRecords memory _parameters,
        bytes4 _cbsCode,
        uint256 _txId
    )
        external
        onlyMunicipality(_cbsCode)
    {
        _validateTransaction(_txId);
        _setIsExecuted(_txId);

        _sPersonalRecords[_parameters.account] = _parameters;
        emit TransactionExecuted(msg.sender, _txId);
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
        bytes4 _cbsCode,
        uint256 _txId
    )
        public
        onlyMunicipality(_cbsCode)
    {
        /* ARRANGE */

        // Get person's residency.
        bytes4 cbsCode = _sPersonalRecords[_person].currentAddress.municipality;

        /* PERFORM ASSERTIONS */

        if (cbsCode != _cbsCode) {
            revert INVALID_PERSON_RESIDENCY(cbsCode, _cbsCode);
        }

        _validateTransaction(_txId);
        _setIsExecuted(_txId);

        _sPersonalRecords[_person].name.first = _firstName;
        emit TransactionExecuted(msg.sender, _txId);
    }

    function updateLastName(
        address _person,
        bytes32 _lastName,
        bytes4 _cbsCode,
        uint256 _txId
    )
        public
        onlyMunicipality(_cbsCode)
    {
        /* ARRANGE */

        // Get person's residency.
        bytes4 cbsCode = _sPersonalRecords[_person].currentAddress.municipality;

        /* PERFORM ASSERTIONS */

        if (cbsCode != _cbsCode) {
            revert INVALID_PERSON_RESIDENCY(cbsCode, _cbsCode);
        }

        _validateTransaction(_txId);
        _setIsExecuted(_txId);

        _sPersonalRecords[_person].name.last = _lastName;
        emit TransactionExecuted(msg.sender, _txId);
    }

    function updateBirthDay(
        address _person,
        bytes4 _cbsCode,
        uint24 _birthDay,
        uint256 _txId
    )
        public
        onlyMunicipality(_cbsCode)
    {
        /* ARRANGE */

        // Get person's residency.
        bytes4 cbsCode = _sPersonalRecords[_person].currentAddress.municipality;

        /* PERFORM ASSERTIONS */

        if (cbsCode != _cbsCode) {
            revert INVALID_PERSON_RESIDENCY(cbsCode, _cbsCode);
        }

        _validateTransaction(_txId);
        _setIsExecuted(_txId);

        _sPersonalRecords[_person].dateOfBirth.day = _birthDay;
        emit TransactionExecuted(msg.sender, _txId);
    }

    function updateBirthMonth(
        address _person,
        bytes4 _cbsCode,
        uint24 _birthMonth,
        uint256 _txId
    )
        public
        onlyMunicipality(_cbsCode)
    {
        /* ARRANGE */

        // Get person's residency.
        bytes4 cbsCode = _sPersonalRecords[_person].currentAddress.municipality;

        /* PERFORM ASSERTIONS */

        if (cbsCode != _cbsCode) {
            revert INVALID_PERSON_RESIDENCY(cbsCode, _cbsCode);
        }

        _validateTransaction(_txId);
        _setIsExecuted(_txId);

        _sPersonalRecords[_person].dateOfBirth.month = _birthMonth;
        emit TransactionExecuted(msg.sender, _txId);
    }

    function updateBirthYear(
        address _person,
        bytes4 _cbsCode,
        uint24 _birthYear,
        uint256 _txId
    )
        public
        onlyMunicipality(_cbsCode)
    {
        /* ARRANGE */

        // Get person's residency.
        bytes4 cbsCode = _sPersonalRecords[_person].currentAddress.municipality;

        /* PERFORM ASSERTIONS */

        if (cbsCode != _cbsCode) {
            revert INVALID_PERSON_RESIDENCY(cbsCode, _cbsCode);
        }

        _validateTransaction(_txId);
        _setIsExecuted(_txId);

        _sPersonalRecords[_person].dateOfBirth.year = _birthYear;
        emit TransactionExecuted(msg.sender, _txId);
    }

    function updateBirthCity(
        address _person,
        bytes4 _cbsCode,
        bytes32 _city,
        uint256 _txId
    )
        public
        onlyMunicipality(_cbsCode)
    {
        /* ARRANGE */

        // Get person's residency.
        bytes4 cbsCode = _sPersonalRecords[_person].currentAddress.municipality;

        /* PERFORM ASSERTIONS */

        if (cbsCode != _cbsCode) {
            revert INVALID_PERSON_RESIDENCY(cbsCode, _cbsCode);
        }

        _validateTransaction(_txId);
        _setIsExecuted(_txId);

        _sPersonalRecords[_person].placeOfBirth.city = _city;
        emit TransactionExecuted(msg.sender, _txId);
    }

    function updateBirthProvince(
        address _person,
        bytes4 _cbsCode,
        bytes32 _province,
        uint256 _txId
    )
        public
        onlyMunicipality(_cbsCode)
    {
        /* ARRANGE */

        // Get person's residency.
        bytes4 cbsCode = _sPersonalRecords[_person].currentAddress.municipality;

        /* PERFORM ASSERTIONS */

        if (cbsCode != _cbsCode) {
            revert INVALID_PERSON_RESIDENCY(cbsCode, _cbsCode);
        }

        _validateTransaction(_txId);
        _setIsExecuted(_txId);

        _sPersonalRecords[_person].placeOfBirth.province = _province;
        emit TransactionExecuted(msg.sender, _txId);
    }

    function updateBirthCountry(
        address _person,
        bytes3 _country,
        bytes4 _cbsCode,
        uint256 _txId
    )
        public
        onlyMunicipality(_cbsCode)
    {
        /* ARRANGE */

        // Get person's residency.
        bytes4 cbsCode = _sPersonalRecords[_person].currentAddress.municipality;

        /* PERFORM ASSERTIONS */

        if (cbsCode != _cbsCode) {
            revert INVALID_PERSON_RESIDENCY(cbsCode, _cbsCode);
        }

        _validateTransaction(_txId);
        _setIsExecuted(_txId);

        _sPersonalRecords[_person].placeOfBirth.country = _country;
        emit TransactionExecuted(msg.sender, _txId);
    }

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
}
