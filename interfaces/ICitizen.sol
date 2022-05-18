// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

interface ICitizen {
    function updateFirstName(string memory _firstName, uint256 _txIndex) external;

    function updateLastName(string memory _lastName, uint256 _txIndex) external;

    function updateBirthtime(uint256 _birthtime, uint256 _txIndex) external;

    function updateBirthDay(uint256 _birthDay, uint256 _txIndex) external;

    function updateBirthMonth(uint256 _birthMonth, uint256 _txIndex) external;

    function updateBirthYear(uint256 _birthYear, uint256 _txIndex) external;

    function updateBirthCity(string memory _city, uint256 _txIndex) external;

    function updateBirthState(string memory _state, uint256 _txIndex) external;

    function updateBirthCountry(string memory _country, uint256 _txIndex) external;

    function updateAccount(address _account, uint256 _txIndex) external;

    function updateBiometricInfoURI(string memory _uri, uint256 _txIndex) external;

    function updatePhotoURI(string memory _uri, uint256 _txIndex) external;

    function updateCitizenship(string memory _citizenship, uint256 _txIndex) external;

    function fullName() external view returns (string memory);

    function firstName() external view returns (string memory);

    function lastName() external view returns (string memory);

    function birthtime() external view returns (uint256);

    function birthDay() external view returns (uint256);

    function birthMonth() external view returns (uint256);

    function birthYear() external view returns (uint256);

    function birthCity() external view returns (string memory);

    function birthState() external view returns (string memory);

    function birthCountry() external view returns (string memory);

    function account() external view returns (address);

    function biometricInfoURI() external view returns (string memory);

    function photoURI() external view returns (string memory);

    function citizenship() external view returns (string memory);
}
