// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@core/addresser/TruhuisAddresserAPI.sol";
import "@interfaces/ITruhuisInspector.sol";
import {PurchaseAgreementStruct} from "@interfaces/IPurchaseAgreement.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ATruhuisInspector
 * @author vsevdrob
 * @notice _
 */
abstract contract ATruhuisInspector is
    Ownable,
    ITruhuisInspector,
    TruhuisAddresserAPI
{
    constructor(address _addresser) {
        updateAddresser(_addresser);
    }

    function _carryOutStructuralInspection(uint256 _purchaseAgreementId)
        internal
    {
        notary().setStructuralInspectionIsDissolved(_purchaseAgreementId);
    }
}
