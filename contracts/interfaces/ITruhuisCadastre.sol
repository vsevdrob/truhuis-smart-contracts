// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface ITruhuisCadastre is IERC721 {


    error NotOwnerError(address account, uint256 tokenId);
    error ProvidedIdenticalTokenUriError(uint256 tokenId, string tokenURI);


    event Minted(address to, uint256 tokenId, string tokenURI);
    event SetTokenURI(uint256 tokenId, string tokenURI);


    function isOwner(address _account, uint256 _tokenId) external view returns (bool);

}
