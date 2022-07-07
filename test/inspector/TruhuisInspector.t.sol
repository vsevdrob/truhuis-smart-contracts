// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@test/Conftest.sol";

/**
 * @title TruhuisInspectorTest
 * @author vsevdrob
 * @dev List of implemented functions to test (PASS | FAIL | TODO):
 *      [PASS] constructor()
 *      [TODO] carryOutStructuralInspection(uint256)
 */
contract TruhuisInspectorTest is Conftest {
    function setUp() public {
        _deploy();
    }

    function testConstructor() external {
        /* ARRANGE */

        // Deploy a new TruhuisInspector contract.
        inspector = new TruhuisInspector(address(addressRegistry));

        /* ACT */

        // Get address registry contract address.
        address addressRegistryAddr = address(appraiser.addressRegistry());

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(address(addressRegistry), addressRegistryAddr);
    }

    //function testCarryOutStructuralInspection(uint256 _purchaseAgreementId)
    //    external
    //{}
}
