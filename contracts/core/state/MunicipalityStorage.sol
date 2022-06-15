// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../../interfaces/IMunicipality.sol";

import {PersonalRecords} from "../../interfaces/IPersonalRecordsDatabase.sol";

abstract contract MunicipalityStorage {
    uint32 internal _sColingOffPeriod; // usually 3 days. Consumer rights.

    uint16 internal _sMunicipalityCBSCode;
}
