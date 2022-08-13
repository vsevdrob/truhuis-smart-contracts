// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import {
    CoolingOffPeriod__InvalidEndTime,
    CoolingOffPeriod__InvalidStartTime,
    CoolingOffPeriod
} from "@interfaces/IPurchaseAgreement.sol";

contract Article16CoolingOffPeriod {
    function _validateCoolingOffPeriod(
        CoolingOffPeriod memory _coolingOffPeriod
    ) internal view {
        /* ARRANGE */

        // Get end time.
        uint256 endTime = _coolingOffPeriod.endTime;

        // Get start time.
        uint256 startTime = _coolingOffPeriod.startTime;

        /* PERFORM ASSERTIONS */

        // `_startTime` must be no shorter than current time.
        if (block.timestamp > startTime) {
            revert CoolingOffPeriod__InvalidStartTime();
        }

        // `_endTime` must last longer than 3 days.
        if (3 days > endTime) {
            revert CoolingOffPeriod__InvalidEndTime();
        }
    }
}
