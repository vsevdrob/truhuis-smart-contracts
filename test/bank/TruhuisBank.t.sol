// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@interfaces/ITruhuisBank.sol";
import "@test/Conftest.sol";

/**
 * @title TruhuisBankTest
 * @author vsevdrob
 * @dev List of implemented functions to test (PASS | FAIL | TODO):
 *      [TODO] constructor(address,string)
 */
contract TruhuisBankTest is Conftest {
    function setUp() external {
        _deploy();
        _updateAddresses();
    }

    function testConstructor() external {
        /* ACT */

        // Get addresser contract address.
        address addresserAddr = address(sBank.addresser());
        // Get contract owner address.
        address contractOwnerAddr = sBank.owner();

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(address(sAddresser), addresserAddr);
        // Actual owner address must be equal to the expected.
        assertEq(sTruhuis, contractOwnerAddr);
    }
}

