// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@core/state/APersonalRecordsDatabase.sol";

/*
 * @title PersonalRecordsDatabase
 * @author vsevdrob
 * @notice _
 */
contract PersonalRecordsDatabase is APersonalRecordsDatabase {
    constructor(address _addresser) APersonalRecordsDatabase(_addresser) {}

    /// @inheritdoc IPersonalRecordsDatabase
    function confirmRequest(uint256 _txId) external {
        _confirmRequest(_txId);
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function storePersonalRecords(
        PersonalRecords memory _parameters,
        bytes4 _cbsCode,
        uint256 _txId
    )
        external
        onlyMunicipality(_cbsCode)
    {
        _storePersonalRecords(_parameters, _cbsCode, _txId);
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function submitRequest(address[1] memory _confirmers) external {
        _submitRequest(_confirmers);
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function updateBirthCity(
        address _person,
        bytes4 _cbsCode,
        bytes32 _city,
        uint256 _txId
    )
        external
        onlyMunicipality(_cbsCode)
    {
        _updateBirthCity(_person, _cbsCode, _city, _txId);
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function updateBirthCountry(
        address _person,
        bytes3 _country,
        bytes4 _cbsCode,
        uint256 _txId
    )
        external
        onlyMunicipality(_cbsCode)
    {
        _updateBirthCountry(_person, _country, _cbsCode, _txId);
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function updateBirthDay(
        address _person,
        bytes4 _cbsCode,
        uint24 _birthDay,
        uint256 _txId
    )
        external
        onlyMunicipality(_cbsCode)
    {
        _updateBirthDay(_person, _cbsCode, _birthDay, _txId);
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function updateBirthMonth(
        address _person,
        bytes4 _cbsCode,
        uint24 _birthMonth,
        uint256 _txId
    )
        external
        onlyMunicipality(_cbsCode)
    {
        _updateBirthMonth(_person, _cbsCode, _birthMonth, _txId);
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function updateBirthProvince(
        address _person,
        bytes4 _cbsCode,
        bytes32 _province,
        uint256 _txId
    )
        external
        onlyMunicipality(_cbsCode)
    {
        _updateBirthProvince(_person, _cbsCode, _province, _txId);
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function updateBirthYear(
        address _person,
        bytes4 _cbsCode,
        uint24 _birthYear,
        uint256 _txId
    )
        external
        onlyMunicipality(_cbsCode)
    {
        _updateBirthYear(_person, _cbsCode, _birthYear, _txId);
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function updateFirstName(
        address _person,
        bytes32 _firstName,
        bytes4 _cbsCode,
        uint256 _txId
    )
        external
        onlyMunicipality(_cbsCode)
    {
        _updateFirstName(_person, _firstName, _cbsCode, _txId);
    }

    /// @inheritdoc IPersonalRecordsDatabase
    function updateLastName(
        address _person,
        bytes32 _lastName,
        bytes4 _cbsCode,
        uint256 _txId
    )
        external
        onlyMunicipality(_cbsCode)
    {
        _updateLastName(_person, _lastName, _cbsCode, _txId);
    }
}
