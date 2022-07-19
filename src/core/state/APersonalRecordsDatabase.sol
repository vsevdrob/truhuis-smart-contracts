// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@core/addresser/TruhuisAddresserAPI.sol";
import "@interfaces/IPersonalRecordsDatabase.sol";
import "@libraries/Signable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title APersonalRecordsDatabase
 * @author vsevdrob
 * @notice _
 */
abstract contract APersonalRecordsDatabase is
    Ownable,
    Signable,
    IPersonalRecordsDatabase,
    TruhuisAddresserAPI
{
    /// @dev Person => Personal records struct.
    mapping(address => PersonalRecords) private _sPersonalRecords;

    modifier onlyMunicipality(bytes4 _cbsCode) {
        /* ARRANGE */

        bool isRegistered = addresser().isRegisteredMunicipality(
            msg.sender,
            _cbsCode
        );

        /* PERFORM ASSERTIONS */

        if (!isRegistered) {
            revert MUNICIPALITY_NOT_REGISTERED();
        }

        _;
    }

    constructor(address _addresser) {
        updateAddresser(_addresser);
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function account(address _person) external view override returns (address) {
        return _sPersonalRecords[_person].account;
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function birthCity(address _person)
        external
        view
        override
        returns (bytes32)
    {
        return _sPersonalRecords[_person].placeOfBirth.city;
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function birthCountry(address _person)
        external
        view
        override
        returns (bytes3)
    {
        return _sPersonalRecords[_person].placeOfBirth.country;
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function birthDay(address _person) external view override returns (uint24) {
        return _sPersonalRecords[_person].dateOfBirth.day;
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function birthMonth(address _person)
        external
        view
        override
        returns (uint24)
    {
        return _sPersonalRecords[_person].dateOfBirth.month;
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function birthProvince(address _person)
        external
        view
        override
        returns (bytes32)
    {
        return _sPersonalRecords[_person].placeOfBirth.province;
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function birthYear(address _person)
        external
        view
        override
        returns (uint24)
    {
        return _sPersonalRecords[_person].dateOfBirth.year;
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function firstName(address _person)
        external
        view
        override
        returns (bytes32)
    {
        return _sPersonalRecords[_person].name.first;
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function fullName(address _person)
        external
        view
        returns (bytes32, bytes32)
    {
        return (
            _sPersonalRecords[_person].name.first,
            _sPersonalRecords[_person].name.last
        );
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function isDutchNationality(address _person)
        external
        view
        override
        returns (bool)
    {
        return
            _sPersonalRecords[_person].residency == Residency.DUTCH_NATIONALITY;
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function lastName(address _person)
        external
        view
        override
        returns (bytes32)
    {
        return _sPersonalRecords[_person].name.last;
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function residency(address _person)
        external
        view
        override
        returns (Residency)
    {
        return _sPersonalRecords[_person].residency;
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function retrievePersonalRecords(address _person)
        external
        view
        override
        returns (PersonalRecords memory)
    {
        return _sPersonalRecords[_person];
    }

    function _confirmRequest(uint256 _txId) internal {
        _confirmTransaction(_txId);
    }

    function _storePersonalRecords(
        PersonalRecords memory _parameters,
        bytes4 _cbsCode,
        uint256 _txId
    ) internal {
        _validateTransaction(_txId);
        _setIsExecuted(_txId);

        _sPersonalRecords[_parameters.account] = _parameters;
        emit TransactionExecuted(msg.sender, _txId);
    }

    function _submitRequest(address[1] memory _confirmers) internal {
        _submitTransaction(_confirmers);
    }

    function _updateBirthCity(
        address _person,
        bytes4 _cbsCode,
        bytes32 _city,
        uint256 _txId
    ) internal {
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

    function _updateBirthCountry(
        address _person,
        bytes3 _country,
        bytes4 _cbsCode,
        uint256 _txId
    ) internal {
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

    function _updateBirthDay(
        address _person,
        bytes4 _cbsCode,
        uint24 _birthDay,
        uint256 _txId
    ) internal {
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

    function _updateBirthMonth(
        address _person,
        bytes4 _cbsCode,
        uint24 _birthMonth,
        uint256 _txId
    ) internal {
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

    function _updateBirthProvince(
        address _person,
        bytes4 _cbsCode,
        bytes32 _province,
        uint256 _txId
    ) internal {
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

    function _updateBirthYear(
        address _person,
        bytes4 _cbsCode,
        uint24 _birthYear,
        uint256 _txId
    ) internal {
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

    function _updateFirstName(
        address _person,
        bytes32 _firstName,
        bytes4 _cbsCode,
        uint256 _txId
    ) internal {
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

    function _updateLastName(
        address _person,
        bytes32 _lastName,
        bytes4 _cbsCode,
        uint256 _txId
    ) internal {
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
}
