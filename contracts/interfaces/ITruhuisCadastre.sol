// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

error NotOwnerError(address account, uint256 tokenId);
error ProvidedIdenticalTokenUriError(uint256 tokenId, string tokenURI);

interface ITruhuisCadastre is IERC721 {

    //event Minted(address to, uint256 tokenId, string tokenURI);
    event SetTokenURI(uint256 tokenId, string tokenURI);

    /**
     * @dev _
     */
    function pause() external;

    /**
     * @dev _
     */
    function unpause() external;

    /**
     * @dev _
     */
    function safeMint(address _to, string memory _tokenURI) external;

    /**
     * @dev _
     */
    function updateContractURI(string memory _contractURI) external;

    /**
     * @dev _
     */
    function isOwner(address _account, uint256 _tokenId)
        external
        view
        returns (bool);
}
