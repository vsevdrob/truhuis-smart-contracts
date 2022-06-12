// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

interface IStateGovernment {
    function registerResident(
        bytes32[] memory _name,
        uint24[] memory _dateOfBirth,
        bytes32[] memory _placeOfBirth,
        address[] memory _account,
        string[] memory _uri,
        bytes3[] memory _citizenship
    ) external;

    function getStateGovernmentAddr() external view returns (address);
    function getStateGovernmentCountry() external view returns (bytes3);
    function getResidentContractAddr(address _citizen) external view returns (address);
    function getCoolingOffPeriod() external view returns (uint32);
    function getTransferTax() external view returns (uint96);
    function isResidentRegistered(address _resident) external view returns (bool);
}
