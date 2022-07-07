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
        /* ACT */

        // Get address registry contract address.
        address addressRegistryAddr = address(appraiser.addressRegistry());
        // Get contract owner address.
        address contractOwnerAddr = appraiser.owner();

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(address(addressRegistry), addressRegistryAddr);
        // Actual owner address must be equal to the expected.
        assertEq(truhuis, contractOwnerAddr);
    }

    //function testCarryOutStructuralInspection(uint256 _purchaseAgreementId)
    //    external
    //{}
}
