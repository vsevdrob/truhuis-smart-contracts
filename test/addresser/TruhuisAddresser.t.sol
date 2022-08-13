// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "../Conftest.sol";
import "@interfaces/ITruhuisAddresser.sol";

/**
 * @title TruhuisAddresserTest
 * @author vsevdrob
 * @dev List of implemented functions to test (PASS | FAIL | TODO):
 *      [PASS] constructor()
 *      [PASS] getAddress(bytes32)
 *      [PASS] getMunicipality(bytes4)
 *      [PASS] isRegisteredMunicipality(address,bytes4)
 *      [PASS] registerMunicipality(address,bytes4)
 *      [PASS] updateAddress(address,bytes32)
 *      [PASS] updateMunicipality(address,bytes4)
 */
contract TruhuisAddresserTest is Conftest {
    function setUp() public {
        _deploy();
    }

    function testConstructor() public {
        /* ACT */

        // Get contract address of the addresser.
        address addresserAddr = sAddresser.getAddress(S_ADDRESSER);

        // Get contract owner address.
        address contractOwnerAddr = sAddresser.owner();

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(address(sAddresser), addresserAddr);
        // Actual contract owner must be equal to the expected.
        assertEq(sTruhuis, contractOwnerAddr);
    }

    function testGetAddress() public {
        /* ARRANGE */

        vm.startPrank(sTruhuis);

        // Update Truhuis Trade contract address.
        sAddresser.updateAddress(address(sTrade), S_TRADE);

        vm.stopPrank();

        /* ACT */

        // Get contract address of the appraiser.
        address appraiserAddr = sAddresser.getAddress(S_APPRAISER);
        // Get contract address of the trade.
        address tradeAddr = sAddresser.getAddress(S_TRADE);

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the zero address.
        assertEq(address(0), appraiserAddr);
        // Actual contract address must be equal to the expected.
        assertEq(address(sTrade), tradeAddr);
    }

    function testGetMunicipality() public {
        /* ARRANGE */

        vm.startPrank(sTruhuis);

        // Register municipality of Amsterdam.
        sAddresser.registerMunicipality(address(sMunicipalityA), S_AMSTERDAM);

        vm.stopPrank();

        /* ACT */

        // Get municipality of Amsterdam.
        MunicipalityStruct memory mA = sAddresser.getMunicipality(S_AMSTERDAM);

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(address(sMunicipalityA), mA.contractAddr);
        // Municipality of Amsterdam identifier must be equal to the expected.
        assertEq(mA.cbsCode, S_AMSTERDAM);
        // Municipality of Amsterdam must be registered.
        assertEq(mA.isRegistered, true);
    }

    function testIsRegisteredMunicipality() public {
        /* ARRANGE */

        vm.startPrank(sTruhuis);

        // Register municipality of Amsterdam.
        sAddresser.registerMunicipality(address(sMunicipalityA), S_AMSTERDAM);

        vm.stopPrank();

        /* ACT */

        // Get whether the municipality registered or not.
        bool isRegisteredA = sAddresser.isRegisteredMunicipality(
            address(sMunicipalityA),
            S_AMSTERDAM
        );

        // Get whether the municipality registered or not.
        bool isRegisteredR = sAddresser.isRegisteredMunicipality(
            address(sMunicipalityR),
            S_ROTTERDAM
        );

        /* PERFORM ASSERTIONS */

        // Municipality of Amsterdam must be registered.
        assertEq(isRegisteredA, true);
        // Municipality of Rotterdam must be not registered.
        assertEq(isRegisteredR, false);
    }

    function testRegisterMunicipality() public {
        /* ARRANGE */

        vm.startPrank(sTruhuis);

        // Register municipality of Amsterdam.
        sAddresser.registerMunicipality(address(sMunicipalityA), S_AMSTERDAM);

        vm.stopPrank();

        /* ACT */

        // Get municipality of Amsterdam.
        MunicipalityStruct memory mA = sAddresser.getMunicipality(S_AMSTERDAM);

        /* PERFORM ASSERTIONS */

        // Expected municipality contract address must be equal to the actual.
        assertEq(address(sMunicipalityA), mA.contractAddr);
        // Municipality of Amsterdam identifier must be equal to the expected.
        assertEq(mA.cbsCode, S_AMSTERDAM);
        // Municipality of Amsterdam must be registered.
        assertEq(mA.isRegistered, true);

        /* REVERT ERRORS */

        vm.startPrank(sTruhuis);

        // Must fail because of default value of an address.
        vm.expectRevert(MUNICIPALITY_REGISTRATION_FAILED.selector);
        sAddresser.registerMunicipality(address(0), S_AMSTERDAM);

        // Must fail because municipality is already registered.
        vm.expectRevert(MUNICIPALITY_REGISTRATION_FAILED.selector);
        sAddresser.registerMunicipality(address(sMunicipalityA), S_AMSTERDAM);

        // Must fail because of default value of a bytes4.
        vm.expectRevert(MUNICIPALITY_REGISTRATION_FAILED.selector);
        sAddresser.registerMunicipality(address(sMunicipalityR), 0x00000000);

        vm.stopPrank();

        // Must fail because caller is not contract owner.
        vm.startPrank(sAlice);
        vm.expectRevert("Ownable: caller is not the owner");
        sAddresser.registerMunicipality(address(sMunicipalityH), S_THE_HAGUE);
        vm.stopPrank();
    }

    function testUpdateAddress() public {
        /* ARRANGE */

        vm.startPrank(sTruhuis);

        // Store updated appraiser contract address.
        sAddresser.updateAddress(address(sAppraiser), S_APPRAISER);
        // Store updated inspector contract address.
        sAddresser.updateAddress(address(sInspector), S_INSPECTOR);

        vm.stopPrank();

        /* ACT */

        // Get appraiser contract address.
        address appraiserAddr = sAddresser.getAddress(S_APPRAISER);
        // Get inspector contract address.
        address inspectorAddr = sAddresser.getAddress(S_INSPECTOR);

        /* PERFORM ASSERTIONS */

        // Actual appraiser address must be equal to the expected.
        assertEq(address(sAppraiser), appraiserAddr);
        // Actual appraiser address must be equal to the expected.
        assertEq(address(sInspector), inspectorAddr);

        /* REVERT ERRORS */

        vm.startPrank(sTruhuis);

        // Must fail because updating the addresser contract address
        // is not allowed.
        vm.expectRevert(UPDATE_ADDRESSER_NOT_ALLOWED.selector);
        sAddresser.updateAddress(address(0x0123), S_ADDRESSER);

        // Must fail because updating a new contract address on top of an
        // identical old contract address is not allowed.
        vm.expectRevert(IDENTICAL_ADDRESS_PROVIDED.selector);
        sAddresser.updateAddress(address(sAppraiser), S_APPRAISER);

        // Must fail because providing the zero address is not permitted.
        vm.expectRevert(ZERO_ADDRESS_PROVIDED.selector);
        sAddresser.updateAddress(address(0), S_APPRAISER);

        vm.stopPrank();

        // Must fail because caller is not contract owner.
        vm.startPrank(sBob);
        vm.expectRevert("Ownable: caller is not the owner");
        sAddresser.updateAddress(address(sInspector), S_INSPECTOR);
        vm.stopPrank();
    }

    function testUpdateMunicipality() public {
        /* ARRANGE */

        vm.startPrank(sTruhuis);

        // Deploy new munciipality of Amsterdam contract.
        Municipality municipalityANew = new Municipality(S_AMSTERDAM);

        // Register municipality of Amsterdam.
        sAddresser.registerMunicipality(address(sMunicipalityA), S_AMSTERDAM);

        // Store updated municipality of Amsterdam contract address.
        sAddresser.updateMunicipality(address(municipalityANew), S_AMSTERDAM);

        vm.stopPrank();

        /* ACT */

        // Get municipality of Amsterdam.
        MunicipalityStruct memory mA = sAddresser.getMunicipality(S_AMSTERDAM);

        /* PERFORM ASSERTIONS */

        // Actual municipality contract address must be equal to the expected.
        assertEq(address(municipalityANew), mA.contractAddr);
        // Actual CBS-code must be identical to the expected.
        assertEq(S_AMSTERDAM, mA.cbsCode);
        // Municipality of Amsterdam must be successfully registered.
        assertEq(mA.isRegistered, true);

        /* REVERT ERRORS */

        vm.startPrank(sTruhuis);

        // Must fail because new address is equal to old address.
        vm.expectRevert(MUNICIPALITY_UPDATE_FAILED.selector);
        sAddresser.updateMunicipality(address(municipalityANew), S_AMSTERDAM);

        // Must fail because providing the zero address is not permitted.
        vm.expectRevert(ZERO_ADDRESS_PROVIDED.selector);
        sAddresser.updateMunicipality(address(0), S_AMSTERDAM);

        vm.stopPrank();

        // Must fail because caller is not contract owner.
        vm.startPrank(sMinistryOfIKR);
        vm.expectRevert("Ownable: caller is not the owner");
        sAddresser.updateMunicipality(address(sMunicipalityH), S_THE_HAGUE);
        vm.stopPrank();
    }
}
