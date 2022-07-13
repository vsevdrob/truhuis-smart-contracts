// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@test/Conftest.sol";

/**
 * @title MunicipalityTest
 * @author vsevdrob
 * @dev List of implemented functions to test (PASS | FAIL | TODO):
 *      [PASS] constructor()
 *      [PASS] getId()
 */
contract MunicipalityTest is Conftest {
    function setUp() public {
        _deploy();
        _updateAddresses();
    }

    function testConstructor() external {
        /* ACT */

        // Get municipality ID.
        bytes4 id = sMunicipalityA.getId();
        // Get contract owner address.
        address contractOwnerAddr = sMunicipalityA.owner();

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(S_AMSTERDAM, id);
        // Actrual contract owner must be equal to the expected.
        assertEq(sAmsterdam, contractOwnerAddr);
    }

    function testGetId() external {
        /* ACT */

        // Get municipality ID.
        bytes4 idA = sMunicipalityA.getId();
        bytes4 idR = sMunicipalityR.getId();
        bytes4 idH = sMunicipalityH.getId();

        /* PERFORM ASSERTIONS */

        // Actual municipality identifier must be identical to the expected.

        assertEq(S_AMSTERDAM, idA);
        assertEq(S_ROTTERDAM, idR);
        assertEq(S_THE_HAGUE, idH);
    }
}
