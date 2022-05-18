// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

interface IGovernment {
    function registerCitizen(
        string[] memory _name,
        int8[] memory _dateOfBirth,
        string[] memory _placeOfBirth,
        address[] memory _account,
        string[] memory _uri,
        string[] memory _citizenship
    ) external;
    
    function getAddress() external view returns (address);
    function getCitizen(address _citizen) external view returns (address);
    function getCountry() external view returns (string memory);
    function getTransferTax() external view returns (uint96);
}
