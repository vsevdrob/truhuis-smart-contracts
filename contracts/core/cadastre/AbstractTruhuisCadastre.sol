// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../address/TruhuisAddressRegistryAdapter.sol";
import {TruhuisCadastreStorage as Storage} from "./TruhuisCadastreStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../../libraries/MultiSig.sol";

abstract contract AbstractTruhuisCadastre is
    ERC721,
    Ownable,
    Pausable,
    ERC721Burnable,
    ERC721URIStorage,
    ERC721Enumerable,
    TruhuisAddressRegistryAdapter,
    Storage,
    MultiSig
{
    error CallerIsNotNFTOwner();
    error CallerIsNotPermitted();
    error InvalidContractURI();
    error TransferCallerIsNotOwnerNorApproved();
    error UseTransferNFTOwnershipFunction();

    event ContractURIUpdated(string contractURI);
    event SetTokenURI(string tokenURI, uint256 tokenId);

    modifier onlyNFTOwner(uint256 _tokenId) {
        if (msg.sender != ownerOf(_tokenId)) {
            revert CallerIsNotNFTOwner();
        }
        _;
    }

    modifier onlyPermitted(uint256 _tokenId) {
        if (
            msg.sender != ownerOf(_tokenId) || msg.sender != address(notary())
        ) {
            revert CallerIsNotPermitted();
        }
        _;
    }

    /**
     * @dev _
     */
    function _allotTokenURI(string memory _tokenURI, uint256 _tokenId)
        internal
        virtual
    {
        /* ALLOT TOKEN URI */

        _setTokenURI(_tokenId, _tokenURI);

        // Emit a {SetTokenURI} event.
        emit SetTokenURI(_tokenURI, _tokenId);
    }

    /**
     * @dev _
     */
    function _produceNFT(address _to, string memory _tokenURI)
        internal
        virtual
    {
        /* ARRANGE */

        // Get available token ID.
        uint256 tokenId = _sTokenIdCounter;

        /* PRODUCE NFT */

        // Mint NFT
        _safeMint(_to, tokenId);

        // Allot token URI to the NFT.
        _allotTokenURI(_tokenURI, tokenId);

        // Increment token ID counter.
        _sTokenIdCounter++;
    }

    /**
     * @dev _
     */
    function _transferNFTOwnership(
        address _from,
        address _to,
        bytes memory _data,
        uint256 _tokenId,
        uint256 _txId
    ) internal virtual {
        /* PERFORM ASSERTIONS */

        // Transfer caller must be an owner or approved.
        if (!_isApprovedOrOwner(_msgSender(), _tokenId)) {
            revert TransferCallerIsNotOwnerNorApproved();
        }

        // Transaction must be submitted and confirmed.
        _validateTransaction(_tokenId, _txId);

        /* TRANSFER NFT OWNERSHIP */

        // Set transaction as executed.
        _setIsExecuted(_tokenId, _txId);

        // Transfer the NFT.
        _safeTransfer(_from, _to, _tokenId, _data);
    }

    /**
     * @dev _
     */
    function _updateContractURI(string memory _contractURI) internal virtual {
        /* UPDATE CONTRACT URI */

        _sContractURI = _contractURI;

        // Emit a {ContractURIUpdated} event.
        emit ContractURIUpdated(_contractURI);
    }

    /**
     * @dev _
     */
    function _isNFTOwner(address _account, uint256 _tokenId)
        internal
        view
        virtual
        returns (bool)
    {
        return _account == ownerOf(_tokenId);
    }

    /* INTERNAL & PRIVATE FUNCTIONS */

    // The following functions are overrides required by Solidity.

    /**
     * @dev _
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

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address,
        address,
        uint256 
    ) public virtual override(ERC721, IERC721) {
        revert UseTransferNFTOwnershipFunction();
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address,
        address,
        uint256
    ) public virtual override(ERC721, IERC721) {
        revert UseTransferNFTOwnershipFunction();
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override(ERC721, IERC721) {
        revert UseTransferNFTOwnershipFunction();
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
        override(ERC721, ERC721Enumerable/*, IERC165*/)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
