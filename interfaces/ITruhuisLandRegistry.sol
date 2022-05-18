// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface ITruhuisLandRegistry is IERC721 {
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address, uint256);
    function isOwner(address _account, uint256 _tokenId) external view returns (bool);
}
