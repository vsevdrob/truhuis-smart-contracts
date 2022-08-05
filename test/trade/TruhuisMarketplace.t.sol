// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@interfaces/ITruhuisMarketplace.sol";
import "@test/Conftest.sol";

/**
 * @title TruhuisMarketplaceTest
 * @author vsevdrob
 * @dev List of implemented functions to test (PASS | FAIL | TODO):
 *      [PASS] constructor(address,string)
 *      [TODO] acceptOffer(address,uint256,uint256)
 *      [TODO] cancelAcceptedOffer(uint256)
 *      [TODO] cancelListing(uint256)
 *      [TODO] cancelOffer(uint256,uint256)
 *      [TODO] createOffer(address,uint256,uint256,uint256)
 *      [TODO] list(address,uint256,uint256)
 *      [TODO] setListingSold(uint256)
 *      [TODO] updateListingCurrency(address,uint256)
 *      [TODO] updateListingPrice(uint256,uint256)
 *      [TODO] updateServiceFee(uint96)
 *      [TODO] getListing(uint256)
 */
contract TruhuisMarketplaceTest is Conftest {
    function setUp() external {
        _deploy();
        _updateAddresses();
    }

    function testConstructor() external {
        /* ACT */

        // Get addresser contract address.
        address addresserAddr = address(sTrade.addresser());
        // Get contract owner address.
        address contractOwnerAddr = sTrade.owner();
        // Get service fee.
        uint96 serviceFee = sTrade.getServiceFee();

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(address(sAddresser), addresserAddr);
        // Actual owner address must be equal to the expected.
        assertEq(sTruhuis, contractOwnerAddr);
        // Actual service fee must be identical to the expected.
        assertEq(sServiceFee, serviceFee);
    }
}

