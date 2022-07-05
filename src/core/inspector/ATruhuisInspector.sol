// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../address/TruhuisAddressRegistryAdapter.sol";
import "../../interfaces/ITruhuisInspector.sol";
import {PurchaseAgreementStruct} from "../../interfaces/IPurchaseAgreement.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ATruhuisInspector
 * @author vsevdrob
 * @notice _
 */
abstract contract ATruhuisInspector is
    Ownable,
    ITruhuisInspector,
    TruhuisAddressRegistryAdapter
{
    constructor(address _addressRegistry) {
        updateAddressRegistry(_addressRegistry);
    }

    function _carryOutStructuralInspection(uint256 _purchaseAgreementId)
        internal
    {
        notary().setStructuralInspectionIsDissolved(_purchaseAgreementId);
    }
}
