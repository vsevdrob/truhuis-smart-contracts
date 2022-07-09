// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@test/Conftest.sol";

/**
 * @title TruhuisCadastreTest
 * @author vsevdrob
 * @dev List of implemented functions to test (PASS | FAIL | TODO):
 *      [PASS] constructor(address,string)
 *      [PASS] allotTokenURI(string,uint256)
 *      [TODO] confirmTransfer(uint256,uint256)
 *      [TODO] exists(uint256)
 *      [TODO] isNFTOwner(uint256)
 *      [TODO] pause()
 *      [TODO] produceNFT(address,string)
 *      [TODO] safeTransferFrom(address,address,uint256)
 *      [TODO] safeTransferFrom(address,address,uint256,bytes)
 *      [TODO] submitTransfer(uint256,uint256)
 *      [TODO] supportsInterface(bytes4)
 *      [TODO] revokeTransferConfirmation(uint256,uint256)
 *      [TODO] tokenURI(uint256)
 *      [TODO] transferFrom(address,address,uint256)
 *      [TODO] transferNFTOwnership(address,address,bytes,uint256,uint256)
 *      [TODO] unpause()
 *      [TODO] updateContractURI(string)
 */
contract TruhuisCadastreTest is Conftest {
    function setUp() external {
        _deploy();
    }

    function testConstructor() external {
        /* ACT */

        // Get address registry contract address.
        address addressRegistryAddr = address(cadastre.addressRegistry());
        // Get contract owner address.
        address contractOwnerAddr = cadastre.owner();
        // Get contract URI.
        string memory contractURI = cadastre.getContractURI();

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(address(addressRegistry), addressRegistryAddr);
        // Actual owner address must be equal to the expected.
        assertEq(truhuis, contractOwnerAddr);
        // Actual contract URI must be identical to the expected.
        assertEq(cadastreContractURI, contractURI);
    }

    function testAllotTokenURI() external {
        vm.startPrank(truhuis);

        /* ARRANGE */

        // Mint 1 NFT of ID 1.
        cadastre.produceNFT(alice, sTokenURI1);
        // Allot a new tokenURI to token ID 1.
        cadastre.allotTokenURI("ipfs://1-new", 1);

        /* ACT */

        // Get token URI of token ID 1.
        string memory newTokenURI1 = cadastre.tokenURI(1);

        /* PERFORM ASSERTIONS */

        // Actual token URI must be equal to the expected.
        assertEq(
            keccak256(bytes("ipfs://1-new")),
            keccak256(bytes(newTokenURI1))
        );

        /* REVERT ERRORS */

        // Can not allot token URI to a non-existent NFT.
        vm.expectRevert("ERC721URIStorage: URI set of nonexistent token");
        cadastre.allotTokenURI(sTokenURI2, 2);

        vm.stopPrank();

        // Except the owner nobody can call the function.
        vm.expectRevert("Ownable: caller is not the owner");
        cadastre.allotTokenURI("ipfs://1-new-new", 1);
    }
}
