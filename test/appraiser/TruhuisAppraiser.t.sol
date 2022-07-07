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
        // Actual contract owner address must be equal to the expected.
        assertEq(truhuis, contractOwnerAddr);
    }
}

