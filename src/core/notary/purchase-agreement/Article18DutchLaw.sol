// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

/**
 * @notice Article 18 Dutch law
 *         This provision has been included to prevent ambiguity about
 *         parties with different nationalities who are involved in the
 *         purchase agreement. By declaring Dutch law applicable, the Dutch
 *         court has authority to settle any disputes arising from the
 *         purchase agreement.
 */

import {
    DutchLaw__IsNotApplied,
    DutchLaw
} from "@interfaces/IPurchaseAgreement.sol";

contract Article18DutchLaw {
    function _validateDutchLaw(DutchLaw memory _dutchLaw)
        internal
        pure
    {
        /* ARRANGE */

        // Get whether Dutch law is applied.
        bool isApplied = _dutchLaw.isApplied;

        /* PERFORM ASSERTIONS */

        // Dutch law must be applied.
        if (!isApplied) {
            revert DutchLaw__IsNotApplied();
        }
    }
}
