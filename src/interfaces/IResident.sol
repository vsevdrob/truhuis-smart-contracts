// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

interface IResident {
    function updateFirstName(bytes32 _firstName, uint256 _txIndex) external;

    function updateLastName(bytes32 _lastName, uint256 _txIndex) external;

    function updateBirthtime(uint256 _birthtime, uint256 _txIndex) external;

    function updateBirthDay(uint256 _birthDay, uint256 _txIndex) external;

    function updateBirthMonth(uint256 _birthMonth, uint256 _txIndex) external;

    function updateBirthYear(uint256 _birthYear, uint256 _txIndex) external;

    function updateBirthCity(bytes32 _city, uint256 _txIndex) external;

    function updateBirthState(bytes32 _state, uint256 _txIndex) external;

    function updateBirthCountry(bytes3 _country, uint256 _txIndex) external;

    function updateAccount(address _account, uint256 _txIndex) external;

    function updateBiometricInfoURI(string memory _uri, uint256 _txIndex)
        external;

    function updatePhotoURI(string memory _uri, uint256 _txIndex) external;

    function addCitizenship(bytes3 _citizenship, uint256 _txIndex) external;

    function deleteCitizenship(bytes3 _citizenship, uint256 _txIndex) external;

    function addResidency(bytes3 _residency, uint256 _txIndex) external;

    function deleteResidency(bytes3 _residency, uint256 _txIndex) external;

    function fullName() external view returns (bytes32, bytes32);

    function firstName() external view returns (bytes32);

    function lastName() external view returns (bytes32);

    function birthtime() external view returns (uint256);

    function birthDay() external view returns (uint256);

    function birthMonth() external view returns (uint256);

    function birthYear() external view returns (uint256);

    function birthCity() external view returns (bytes32);

    function birthState() external view returns (bytes32);

    function birthCountry() external view returns (bytes3);

    function account() external view returns (address);

    function biometricInfoURI() external view returns (string memory);

    function photoURI() external view returns (string memory);

    function citizenships() external view returns (bytes3[] memory);

    function residencies() external view returns (bytes3[] memory);

    function isCitizenOf(bytes3 _country) external view returns (bool);

    function isResidentOf(bytes3 _country) external view returns (bool);

    function isAllowedToPurchaseRealEstate(bytes3 _country)
        external
        view
        returns (bool);

    function residentialNftId() external view returns (uint256);
}
