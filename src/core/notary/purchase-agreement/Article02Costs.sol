// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {
    Costs__CostsMustBeGreaterThanZero,
    Costs__PayerMustBeNotNone,
    Costs,
    Party
} from "@interfaces/IPurchaseAgreement.sol";

contract Article02Costs {
    function _validateCosts(Costs memory _costs) internal pure {
        /* ARRANGE */

        // Get cadastre costs.
        uint256 cadastreCosts = _costs.cadastre.amount;

        // Get trade costs.
        uint256 tradeCosts = _costs.trade.amount;

        // Get notary costs.
        uint256 notaryCosts = _costs.notary.amount;

        // Get sales tax costs.
        uint256 salesTaxCosts = _costs.taxAdministration.salesTaxAmount;

        // Get transfer tax costs.
        uint256 transferTaxCosts = _costs.taxAdministration.transferTaxAmount;

        // Get cadastre costs payer.
        Party cadastreCostsPayer = _costs.cadastre.payer;

        // Get trade costs payer.
        Party tradeCostsPayer = _costs.trade.payer;

        // Get notary costs payer.
        Party notaryCostsPayer = _costs.notary.payer;

        // Get sales tax costs payer.
        Party salesTaxCostsPayer = _costs.taxAdministration.payer;

        // Get transfer tax costs payer.
        Party transferTaxCostsPayer = _costs.taxAdministration.payer;

        /* PERFORM ASSERTIONS */

        // Costs must be greater than zero.
        if (
            0 >= cadastreCosts ||
            0 >= tradeCosts ||
            0 >= notaryCosts ||
            0 >= salesTaxCosts ||
            0 >= transferTaxCosts
        ) {
            revert Costs__CostsMustBeGreaterThanZero();
        }

        // Payer must be the buyer or the seller.
        if (
            cadastreCostsPayer == Party.NONE ||
            tradeCostsPayer == Party.NONE ||
            notaryCostsPayer == Party.NONE ||
            salesTaxCostsPayer == Party.NONE ||
            transferTaxCostsPayer == Party.NONE
        ) {
            revert Costs__PayerMustBeNotNone();
        }
    }
}
