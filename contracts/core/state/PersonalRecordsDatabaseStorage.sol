// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {PersonalRecords} from "../../interfaces/IPersonalRecordsDatabase.sol";

contract PersonalRecordsDatabaseStorage {
    mapping(address => PersonalRecords) internal _sPersonalRecords;
}
