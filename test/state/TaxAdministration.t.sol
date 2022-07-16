// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@test/Conftest.sol";

/**
 * @title TaxAdministrationTest
 * @author vsevdrob
 * @dev List of implemented functions to test (PASS | FAIL | TODO):
 *      [PASS] constructor()
 *      [PASS] getTax(uint256)
 *      [PASS] updateTax(uint256,uint96)
 */
contract TaxAdministrationTest is Conftest {
    function setUp() public {
        _deploy();
        _updateAddresses();
        _updateTax();
    }

    function testConstructor() external {
        /* ACT */

        // Get contract owner address.
        address contractOwnerAddr = sTaxAdministration.owner();

        /* PERFORM ASSERTIONS */

        // Actrual contract owner must be equal to the expected.
        assertEq(sMinistryOfFin, contractOwnerAddr);
    }

    function testGetTax() external {
        /* ACT */

        // Get basis tariff for transfer tax.
        uint96 transferTax = sTaxAdministration.getTax(sTaxIdOne);

        /* PERFORM ASSERTIONS */

        // Actual transfer tax amount must be identical to the expected.
        assertEq(sTransferTaxBasis, transferTax);
    }

    function updateTax() external {
        /* ARRANGE */

        // Get tax ID for the next tax.
        uint256 taxIdTwo = 2;
        // Get transfer tax for a non-basis tariff.
        uint96 transferTax = 800; // 8%

        /* ACT */

        // Update tax.
        vm.startPrank(sMinistryOfFin);
        sTaxAdministration.updateTax(taxIdTwo, transferTax);
        vm.stopPrank();

        // Get expected transfer tax tariff.
        uint256 expectedTax = sTaxAdministration.getTax(taxIdTwo);

        /* PERFORM ASSERTIONS */

        // Actual transfer tax must be equal to the expected.
        assertEq(transferTax, expectedTax);
    }
}
