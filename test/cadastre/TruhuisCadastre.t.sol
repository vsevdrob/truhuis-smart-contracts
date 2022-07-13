// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@interfaces/ITruhuisCadastre.sol";
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
 *      [TODO] pauseContract()
 *      [TODO] produceNFT(address,string)
 *      [TODO] safeTransferFrom(address,address,uint256)
 *      [TODO] safeTransferFrom(address,address,uint256,bytes)
 *      [TODO] submitTransfer(uint256,uint256)
 *      [TODO] supportsInterface(bytes4)
 *      [TODO] revokeTransferConfirmation(uint256,uint256)
 *      [TODO] tokenURI(uint256)
 *      [TODO] transferFrom(address,address,uint256)
 *      [TODO] transferNFTOwnership(address,address,bytes,uint256,uint256)
 *      [TODO] unpauseContract()
 *      [PASS] updateContractURI(string)
 */
contract TruhuisCadastreTest is Conftest {
    function setUp() external {
        _deploy();
        _updateAddresses();
    }

    function testConstructor() external {
        /* ACT */

        // Get addresser contract address.
        address addresserAddr = address(sCadastre.addresser());
        // Get contract owner address.
        address contractOwnerAddr = sCadastre.owner();
        // Get contract URI.
        string memory contractURI = sCadastre.getContractURI();

        /* PERFORM ASSERTIONS */

        // Actual contract address must be equal to the expected.
        assertEq(address(sAddresser), addresserAddr);
        // Actual owner address must be equal to the expected.
        assertEq(sTruhuis, contractOwnerAddr);
        // Actual contract URI must be identical to the expected.
        assertEq(sCadastreContractURI, contractURI);
    }

    function testAllotTokenURI() external {
        vm.startPrank(sTruhuis);

        /* ARRANGE */

        // Mint 1 NFT of ID 1.
        sCadastre.produceNFT(sAlice, sTokenURI1);
        // Allot a new tokenURI to token ID 1.
        sCadastre.allotTokenURI("ipfs://1-new", 1);

        /* ACT */

        // Get token URI of token ID 1.
        string memory newTokenURI1 = sCadastre.tokenURI(1);

        /* PERFORM ASSERTIONS */

        // Actual token URI must be equal to the expected.
        assertEq(
            keccak256(bytes("ipfs://1-new")),
            keccak256(bytes(newTokenURI1))
        );

        /* REVERT ERRORS */

        // Can not allot token URI to a non-existent NFT.
        vm.expectRevert("ERC721URIStorage: URI set of nonexistent token");
        sCadastre.allotTokenURI(sTokenURI2, 2);

        vm.stopPrank();

        // Except the owner nobody can call the function.
        vm.expectRevert("Ownable: caller is not the owner");
        sCadastre.allotTokenURI("ipfs://1-new-new", 1);
    }

    //function testConfirmTransfer() external {}

    //function testExists() external {}

    //function testIsNFTOwner() external {}

    //function testPauseContract() external {}

    //function testProduceNFT() external {}

    //function testSafeTransferFrom() external {}

    //function testSafeTransferFrom() external {}

    //function testSubmitTransfer() external {}

    //function testSupportsInterface() external {}

    //function testRevokeTransferConfirmation() external {}

    //function testTokenURI() external {}

    //function testTransferFrom() external {}

    //function testTransferNFTOwnership() external {}

    //function testUnpauseContract() external {}

    function testUpdateContractURI() external {
        vm.startPrank(sTruhuis);

        /* ARRANGE */

        // Old contract URI.
        string memory oldContractURI = sCadastre.getContractURI();
        // New contract URI.
        string memory newContractURI = "ipfs://new-contract-uri";

        /* ACT */

        // Update contract URI.
        sCadastre.updateContractURI(newContractURI);

        /* PERFORM ASSERTIONS */

        // Actual contract URI must be identical to the expected.
        assertEq(
            keccak256(bytes(newContractURI)),
            keccak256(bytes(sCadastre.getContractURI()))
        );

        /* REVERT ERRORS */

        // Providing identical contract URI is not allowed.
        vm.expectRevert(PROVIDED_IDENTICAL_CONTRACT_URI.selector);
        sCadastre.updateContractURI(newContractURI);

        vm.stopPrank();

        // Except the owner nobody is allowed to call the function.
        vm.expectRevert("Ownable: caller is not the owner");
        sCadastre.updateContractURI("ipfs://another-one");
    }
}
