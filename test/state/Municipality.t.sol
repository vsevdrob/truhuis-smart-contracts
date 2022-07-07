// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@test/Conftest.sol";

/**
 * @title MunicipalityTest
 * @author vsevdrob
 * @dev List of implemented functions to test (PASS | FAIL | TODO):
 *      [TODO] constructor()
 */
contract MunicipalityTest is Conftest {
    function setUp() public {
        _deploy();
    }

    function testConstructor() external {
        /* ACT */

        // Get municipality ID.
        bytes4 id = municipalityA.getId();
        // Get contract owner address.
        address contractOwnerAddr = municipalityA.owner();

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(AMSTERDAM, id);
        // Actrual contract owner must be equal to the expected.
        assertEq(amsterdam, contractOwnerAddr);
    }

    function testGetId() external {
        /* ACT */

        // Get municipality ID.
        bytes4 idA = municipalityA.getId();
        bytes4 idR = municipalityR.getId();
        bytes4 idH = municipalityH.getId();

        /* PERFORM ASSERTIONS */

        // Actual municipality identifier must be identical to the expected.

        assertEq(AMSTERDAM, idA);
        assertEq(ROTTERDAM, idR);
        assertEq(THE_HAGUE, idH);
    }
}
