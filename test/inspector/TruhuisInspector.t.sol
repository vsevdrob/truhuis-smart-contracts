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
        _updateAddresses();
    }

    function testConstructor() external {
        /* ACT */

        // Get addresser contract address.
        address addresserAddr = address(sInspector.addresser());
        // Get contract owner address.
        address contractOwnerAddr = sInspector.owner();

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(address(sAddresser), addresserAddr);
        // Actual owner address must be equal to the expected.
        assertEq(sTruhuis, contractOwnerAddr);
    }

    //function testCarryOutStructuralInspection(uint256 _purchaseAgreementId)
    //    external
    //{}
}
