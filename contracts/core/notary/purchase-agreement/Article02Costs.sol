// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {
    Costs__CostsMustBeGreaterThanZero,
    Costs__PayerMustBeNotNone,
    Costs,
    Party
} from "../../../interfaces/IPurchaseAgreement.sol";

contract Article02Costs {
    function _validateCosts(Costs memory _costs) internal pure {
        /* ARRANGE */

        // Get cadastre costs.
        uint256 cadastreCosts = _costs.cadastre.costs;

        // Get marketplace costs.
        uint256 marketplaceCosts = _costs.marketplace.costs;

        // Get notary costs.
        uint256 notaryCosts = _costs.notary.costs;

        // Get sales tax costs.
        uint256 salesTaxCosts = _costs.salesTax.costs;

        // Get transfer tax costs.
        uint256 transferTaxCosts = _costs.transferTax.costs;

        // Get cadastre costs payer.
        Party cadastreCostsPayer = _costs.cadastre.payer;

        // Get marketplace costs payer.
        Party marketplaceCostsPayer = _costs.marketplace.payer;

        // Get notary costs payer.
        Party notaryCostsPayer = _costs.notary.payer;

        // Get sales tax costs payer.
        Party salesTaxCostsPayer = _costs.salesTax.payer;

        // Get transfer tax costs payer.
        Party transferTaxCostsPayer = _costs.transferTax.payer;

        /* PERFORM ASSERTIONS */

        // Costs must be greater than zero.
        if (
            0 >= cadastreCosts ||
            0 >= marketplaceCosts ||
            0 >= notaryCosts ||
            0 >= salesTaxCosts ||
            0 >= transferTaxCosts
        ) {
            revert Costs__CostsMustBeGreaterThanZero();
        }

        // Payer must be the buyer or the seller.
        if (
            cadastreCostsPayer == Party.NONE ||
            marketplaceCostsPayer == Party.NONE ||
            notaryCostsPayer == Party.NONE ||
            salesTaxCostsPayer == Party.NONE ||
            transferTaxCostsPayer == Party.NONE
        ) {
            revert Costs__PayerMustBeNotNone();
        }
    }
}
