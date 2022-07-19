// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

error MUNICIPALITY_NOT_REGISTERED();
error INVALID_PERSON_RESIDENCY(bytes4 actual, bytes4 required);

enum CivilStatus {
    UNMARRIED,
    MARRIED,
    REGISTERED_PARTNERSHIP,
    DIVORCED,
    WIDOW,
    WIDOWER
}

enum Gender {
    FEMALE,
    MALE,
    UNKNOWN
}

enum Residency {
    DUTCH_NATIONALITY,
    PRIVILEGE,
    RESIDENCE_PERMIT,
    PENDING_CONSIDERATION_OF_THE_APPLICATION_FOR_A_RESIDENCE_PERMIT,
    NONE
}

struct Name {
    bytes32 first;
    bytes32 last;
}

struct DateOfBirth {
    uint24 day;
    uint24 month;
    uint24 year;
}

struct PlaceOfBirth {
    bytes32 city;
    bytes32 province;
    bytes3 country;
}

struct Parents {
    address father;
    address mother;
}

struct Children {
    bool hasChildren;
    address[3] childrenAccounts;
}

struct CurrentAddress {
    bytes32 street;
    uint8 houseNumber;
    bytes7 postcode;
    bytes4 municipality; // CBS-code
}

struct PersonalRecords {
    Name name;
    Gender gender;
    address account;
    DateOfBirth dateOfBirth;
    PlaceOfBirth placeOfBirth;
    Parents parents;
    CivilStatus civilState;
    Children children;
    Residency residency;
    CurrentAddress currentAddress;
}

interface IPersonalRecordsDatabase {
    /**
     * @dev _
     */
    function confirmRequest(uint256 _txId) external;

    /**
     * @dev _
     */
    function storePersonalRecords(
        PersonalRecords memory _parameters,
        bytes4 _cbsCode,
        uint256 _txId
    ) external;

    /**
     * @dev _
     */
    function submitRequest(address[1] memory _confirmers) external;

    /**
     * @dev _
     */
    function updateBirthCity(
        address _person,
        bytes4 _cbsCode,
        bytes32 _city,
        uint256 _txId
    ) external;

    /**
     * @dev _
     */
    function updateBirthCountry(
        address _person,
        bytes3 _country,
        bytes4 _cbsCode,
        uint256 _txId
    ) external;

    /**
     * @dev _
     */
    function updateBirthDay(
        address _person,
        bytes4 _cbsCode,
        uint24 _birthDay,
        uint256 _txId
    ) external;

    /**
     * @dev _
     */
    function updateBirthMonth(
        address _person,
        bytes4 _cbsCode,
        uint24 _birthMonth,
        uint256 _txId
    ) external;

    /**
     * @dev _
     */
    function updateBirthProvince(
        address _person,
        bytes4 _cbsCode,
        bytes32 _province,
        uint256 _txId
    ) external;

    /**
     * @dev _
     */
    function updateBirthYear(
        address _person,
        bytes4 _cbsCode,
        uint24 _birthYear,
        uint256 _txId
    ) external;

    /**
     * @dev _
     */
    function updateFirstName(
        address _person,
        bytes32 _firstName,
        bytes4 _cbsCode,
        uint256 _txId
    ) external;

    /**
     * @dev _
     */
    function updateLastName(
        address _person,
        bytes32 _lastName,
        bytes4 _cbsCode,
        uint256 _txId
    ) external;

    /**
     * @dev _
     */
    function account(address _person) external view returns (address);

    /**
     * @dev _
     */
    function birthCity(address _person) external view returns (bytes32);

    /**
     * @dev _
     */
    function birthCountry(address _person) external view returns (bytes3);

    /**
     * @dev _
     */
    function birthDay(address _person) external view returns (uint24);

    /**
     * @dev _
     */
    function birthMonth(address _person) external view returns (uint24);

    /**
     * @dev _
     */
    function birthProvince(address _person) external view returns (bytes32);

    /**
     * @dev _
     */
    function birthYear(address _person) external view returns (uint24);

    /**
     * @dev _
     */
    function firstName(address _person) external view returns (bytes32);

    /**
     * @dev _
     */
    function fullName(address _person) external view returns (bytes32, bytes32);

    /**
     * @dev _
     */
    function isDutchNationality(address _person) external view returns (bool);

    /**
     * @dev _
     */
    function lastName(address _person) external view returns (bytes32);

    /**
     * @dev _
     */
    function residency(address _person) external view returns (Residency);

    /**
     * @dev _
     */
    function retrievePersonalRecords(address _person)
        external
        view
        returns (PersonalRecords memory);
}
