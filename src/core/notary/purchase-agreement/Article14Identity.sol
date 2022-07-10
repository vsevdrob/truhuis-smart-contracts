// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@libraries/IdentificationLogic.sol";
import {Identity} from "@interfaces/IPurchaseAgreement.sol";

contract Article14Identity is IdentificationLogic {
    function _validateIdentity(uint256 _tokenId, Identity memory _identity)
        internal
        view
    {
        /* ARRANGE */

        // Get buyer address.
        address buyer = _identity.buyer.account;

        // Get seller address.
        address seller = _identity.seller.account;

        /* PERFORM ASSERTIONS */

        // Identify buyer.
        _identifyBuyer(buyer, _tokenId);

        // Identify seller.
        _identifySeller(seller, _tokenId);
    }
}
