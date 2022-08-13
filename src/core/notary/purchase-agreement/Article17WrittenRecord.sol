// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import {
    WrittenRecord__BuyerMustSign,
    WrittenRecord__SellerMustSign,
    WrittenRecord
} from "@interfaces/IPurchaseAgreement.sol";

contract Article17WrittenRecord {
    function _validateWrittenRecord(WrittenRecord memory _writtenRecord)
        internal
        pure
    {
        /* ARRANGE */

        // Get whether buyer signed.
        bool hasBuyerSigned = _writtenRecord.hasBuyerSigned;

        // Get whether seller signed.
        bool hasSellerSigned = _writtenRecord.hasSellerSigned;

        /* PERFORM ASSERTIONS */

        // Buyer must have signed.
        if (!hasBuyerSigned) {
            revert WrittenRecord__BuyerMustSign();
        }

        // Seller must have signed.
        if (!hasSellerSigned) {
            revert WrittenRecord__SellerMustSign();
        }
    }
}
