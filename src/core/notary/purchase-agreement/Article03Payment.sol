// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {Payment, Payment__AlreadyFulfilled} from "../../../interfaces/IPurchaseAgreement.sol";

contract Article03Payment {
    function _validatePayment(Payment memory _payment) internal pure {
        /* ARRANGE */

        // Get whether payment already fulfilled or not.
        bool isFulfilled = _payment.isFulfilled;

        /* PERFORM ASSERTIONS */

        // Payment must be not already fulfilled.
        if (isFulfilled) {
            revert Payment__AlreadyFulfilled();
        }
    }
}
