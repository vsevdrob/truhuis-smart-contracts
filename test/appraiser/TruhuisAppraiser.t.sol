// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@test/Conftest.sol";

/**
 * @title TruhuisAppraiserTest
 * @author vsevdrob
 * @dev List of implemented functions to test (PASS | FAIL | TODO):
 *      [PASS] constructor()
 */
contract TruhuisAppraiserTest is Conftest {
    function setUp() public {
        _deploy();
    }

    function testConstructor() external {
        /* ARRANGE */

        // Deploy a new TruhuisAppraiser contract.
        appraiser = new TruhuisAppraiser(address(addressRegistry));

        /* ACT */
        
        // Get address registry contract address.
        address addressRegistryAddr = address(appraiser.addressRegistry());

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(address(addressRegistry), addressRegistryAddr);
    }
}

