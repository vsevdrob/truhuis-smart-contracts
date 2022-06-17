// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../address/TruhuisAddressRegistryAdapter.sol";
import {TruhuisCadastreStorage as Storage} from "./TruhuisCadastreStorage.sol";
import "../../interfaces/ITruhuisCadastre.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

abstract contract TruhuisCadastre is
    ERC721,
    Ownable,
    Pausable,
    ERC721Burnable,
    ERC721URIStorage,
    ERC721Enumerable,
    TruhuisAddressRegistryAdapter,
    Storage,
    ITruhuisCadastre
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    modifier isValidTokenURI(uint256 _tokenId, string memory _tokenURI) {
        bytes32 bTokenURI = keccak256(bytes(_tokenURI));

        require(
            bTokenURI.length > 0,
            "validTokenURI: Token URI can not be empty string."
        );

        if (_tokenId != 0) {
            bytes32 bExistingTokenURI = keccak256(bytes(tokenURI(_tokenId)));

            if (bTokenURI == bExistingTokenURI) {
                revert ProvidedIdenticalTokenUriError(_tokenId, _tokenURI);
            }
        }
        _;
    }

    constructor(string memory _contractURI, address _addressRegistry)
        ERC721("Truhuis Cadastre", "TCA")
    {
        _sContractURI = _contractURI;
        updateAddressRegistry(_addressRegistry);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function updateContractURI(string memory _contractURI) external onlyOwner {
        _sContractURI = _contractURI;
    }

    function safeMint(address _to, string memory _tokenURI)
        public
        onlyOwner
        isValidTokenURI(_tokenIdCounter.current(), _tokenURI)
    {
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, _tokenURI);
    }

    function setTokenURI(uint256 _tokenId, string memory _tokenURI)
        public
        onlyOwner
        isValidTokenURI(_tokenId, _tokenURI)
    {
        _setTokenURI(_tokenId, _tokenURI);
        emit SetTokenURI(_tokenId, _tokenURI);
    }

    /// @inheritdoc ITruhuisCadastre
    function isOwner(address _account, uint256 _tokenId)
        public
        view
        override
        returns (bool)
    {
        return _account == ownerOf(_tokenId);
    }

    /* INTERNAL & PRIVATE FUNCTIONS */

    // The following functions are overrides required by Solidity.

    /**
     *
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        virtual
        override(ERC721, ERC721URIStorage)
    {
        require(_exists(tokenId), "Token ID set of nonexistent token.");
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721Enumerable, IERC165)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
