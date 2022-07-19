// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@test/Conftest.sol";

/**
 * @title PersonalRecordsDatabaseTest
 * @author vsevdrob
 * @dev List of implemented functions to test (PASS | FAIL | TODO):
 *      [TODO] account(address)
 *      [TODO] birthCity(address)
 *      [TODO] birthCountry(address)
 *      [TODO] birthDay(address)
 *      [TODO] birthMonth(address)
 *      [TODO] birthProvince(address)
 *      [TODO] birthYear(address)
 *      [TODO] firstName(address)
 *      [TODO] fullName(address)
 *      [TODO] isDutchNationality(address)
 *      [TODO] lastName(address)
 *      [TODO] residency(address)
 *      [TODO] retrievePersonalRecords(address)
 *      [TODO] confirmRequest(uint256)
 *      [TODO] storePersonalRecords(PersonalRecords memory,bytes4,uint256)
 *      [TODO] submitRequest(address[1] memory)
 *      [TODO] updateBirthCity(address,bytes4,bytes32,uint256)
 *      [TODO] updateBirthCountry(address,bytes3,bytes4,uint256)
 *      [TODO] updateBirthDay(address,bytes4,uint24,uint256)
 *      [TODO] updateBirthMonth(address,bytes4,uint24,uint256)
 *      [TODO] updateBirthProvince(address,bytes4,bytes32,uint256)
 *      [TODO] updateBirthYear(address,bytes4,uint24,uint256)
 *      [TODO] updateFirstName(address,bytes32,bytes4,uint256)
 *      [TODO] updateLastName(address,bytes32,bytes4,uint256)
 */
contract PersonalRecordsDatabaseTest is Conftest {
    function setUp() public {
        _deploy();
        _updateAddresses();
        _storeBuyersPersonalRecords();
        _storeSellersPersonalRecords();
    }

    function testConstructor() external {
        /* ACT */

        // Get contract owner address.
        address contractOwnerAddr = sPersonalRecordsDatabase.owner();

        /* PERFORM ASSERTIONS */

        // Actrual contract owner must be equal to the expected.
        assertEq(sMinistryOfIKR, contractOwnerAddr);
    }
}
