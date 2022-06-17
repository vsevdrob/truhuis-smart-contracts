// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {PersonalRecords} from "./IPersonalRecordsDatabase.sol";

interface IMunicipality {
    function registerPerson(PersonalRecords calldata _parameters) external;

    function updatedCoolingOffPeriod(uint32 _coolingOffPeriod) external;

    function getStateGovernmentAddr() external view returns (address);

    function getStateGovernmentCountry() external view returns (bytes3);

    function getCoolingOffPeriod() external view returns (uint32);

    function isPersonRegistered(address _person) external view returns (bool);
}
