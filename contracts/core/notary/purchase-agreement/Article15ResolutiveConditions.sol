// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {
    ResolutiveConditions__InvalidDeadlines,
    ResolutiveConditions__InvalidInspector,
    ResolutiveConditions
} from "../../../interfaces/IPurchaseAgreement.sol";

contract Article15ResolutiveConditions {
    function _validateResolutiveConditions(
        ResolutiveConditions memory _resolutiveConditions
    ) internal view {
        /* ARRANGE */

        // Get structural inspector address.
        address inspector = _resolutiveConditions
            .structuralInspection
            .inspector;

        // Get deadline to inspect.
        uint256 deadlineToInspect = _resolutiveConditions
            .structuralInspection
            .deadlineToInspect;

        // Get deadline of financing arranging.
        uint256 deadlineToArrange = _resolutiveConditions
            .financingArranging
            .deadlineToArrange;

        /* PERFORM ASSERTIONS */

        // Inspector must be valid.
        if (inspector == address(0)) {
            revert ResolutiveConditions__InvalidInspector();
        }

        // Deadlines must be greater than current time.
        if (
            block.timestamp > deadlineToArrange ||
            block.timestamp > deadlineToInspect
        ) {
            revert ResolutiveConditions__InvalidDeadlines();
        }
    }
}
