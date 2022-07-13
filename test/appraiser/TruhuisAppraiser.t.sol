// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@test/Conftest.sol";

/**
 * @title TruhuisAppraiserTest
 * @author vsevdrob
 * @dev List of implemented functions to test (PASS | FAIL | TODO):
 *      [TODO] constructor()
 */
contract TruhuisAppraiserTest is Conftest {
    function setUp() public {
        _deploy();
        _updateAddresses();
    }

    function testConstructor() external {
        /* ACT */
        
        // Get addresser contract address.
        address addresserAddr = address(sAppraiser.addresser());
        // Get contract owner address.
        address contractOwnerAddr = sAppraiser.owner();

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(address(sAddresser), addresserAddr);
        // Actual contract owner address must be equal to the expected.
        assertEq(sTruhuis, contractOwnerAddr);
    }
}

