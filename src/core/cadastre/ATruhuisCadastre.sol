// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@core/addresser/TruhuisAddresserAPI.sol";
import "@interfaces/ITruhuisCadastre.sol";
import "@libraries/MultiSignable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

abstract contract ATruhuisCadastre is
    Ownable,
    ERC721,
    ERC721Burnable,
    ERC721URIStorage,
    ERC721Enumerable,
    Pausable,
    MultiSignable,
    TruhuisAddresserAPI,
    ITruhuisCadastre
{
    /* PRIVATE STORAGE */

    /// @dev Token ID => Account => Whether granted or not
    mapping(uint256 => mapping(address => bool)) private _sDidAllow;

    /// @dev Contract URI holder.
    string private _sContractURI;

    /// @dev Token ID counter.
    uint256 private _sTokenIds = 1;

    /* MODIFIERS */

    modifier onlyNFTOwner(uint256 _tokenId) {
        if (msg.sender != ownerOf(_tokenId)) {
            revert CALLER_NOT_NFT_OWNER();
        }
        _;
    }

    modifier onlyPermitted(uint256 _tokenId) {
        if (
            msg.sender != ownerOf(_tokenId) && msg.sender != address(notary())
        ) {
            revert CALLER_NOT_PERMITTED(msg.sender);
        }
        _;
    }

    constructor(address _addresser, string memory _contractURI)
        ERC721("Truhuis Cadastre", "TCA")
    {
        updateAddresser(_addresser);
        _updateContractURI(_contractURI);
    }

    /// @inheritdoc ITruhuisCadastre
    function exists(uint256 _tokenId) external view override returns (bool) {
        return _exists(_tokenId);
    }

    // @inheritdoc ITruhuisCadastre
    function getContractURI() external view override returns (string memory) {
        return _sContractURI;
    }

    /// @inheritdoc ITruhuisCadastre
    function isNFTOwner(address _account, uint256 _tokenId)
        external
        view
        override
        returns (bool)
    {
        return _account == ownerOf(_tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address,
        address,
        uint256
    ) public virtual override(ERC721, IERC721) {
        revert INACTIVE_FUNCTION();
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
        revert INACTIVE_FUNCTION();
    }

    /**
     * @dev See {IERC165}
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721Enumerable, IERC165)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {ERC721URIStorage-tokenURI}
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address,
        address,
        uint256
    ) public virtual override(ERC721, IERC721) {
        revert INACTIVE_FUNCTION();
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

        // Emit a {TokenURISet} event.
        emit TokenURISet(_tokenURI, _tokenId);
    }

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

    /**
     * @dev See {ERC721-burn}
     */
    function _burn(uint256 tokenId)
        internal
        virtual
        override(ERC721, ERC721URIStorage)
    {
        require(_exists(tokenId), "Token ID set of nonexistent token.");
        super._burn(tokenId);
    }

    function _confirmTransfer(uint256 _tokenId, uint256 _txId)
        internal
        virtual
    {
        _confirmTransaction(_tokenId, _txId);
    }

    /**
     * @dev _
     */
    function _pauseContract() internal virtual {
        _pause();
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
        uint256 tokenId = _sTokenIds;

        /* PRODUCE NFT */

        // Mint NFT.
        _safeMint(_to, tokenId);

        // Allot token URI to the NFT.
        _allotTokenURI(_tokenURI, tokenId);

        // Increment token ID counter.
        _sTokenIds++;
    }

    /**
     * @dev _
     */
    function _revokeTransferConfirmation(uint256 _tokenId, uint256 _txId)
        internal
        virtual
    {
        _revokeConfirmation(_tokenId, _txId);
    }

    /**
     * @dev _
     */
    function _submitTransfer(uint256 _purchaseAgreementId, uint256 _tokenId)
        internal
        virtual
    {
        _submitTransaction(
            _getConfirmers(_purchaseAgreementId, _tokenId),
            _tokenId
        );
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
            revert CALLER_NOT_NFT_OWNER_NOR_APPROVED();
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
    function _unpauseContract() internal virtual {
        _unpause();
    }

    /**
     * @dev _
     */
    function _updateContractURI(string memory _contractURI) internal virtual {
        /* PERFORM ASSERTIONS */

        // New contract URI must be not identical to the old.
        if (keccak256(bytes(_contractURI)) == keccak256(bytes(_sContractURI))) {
            revert PROVIDED_IDENTICAL_CONTRACT_URI();
        }

        /* UPDATE CONTRACT URI */

        _sContractURI = _contractURI;

        // Emit a {ContractURIUpdated} event.
        emit ContractURIUpdated(_contractURI);
    }

    /**
     * @dev _
     */
    function _getConfirmers(uint256 _purchaseAgreementId, uint256 _tokenId)
        private
        view
        returns (address[3] memory)
    {
        /* ARRANGE */

        // Get co-seller if exists.
        address coSeller = notary()
            .getPurchaseAgreement(_purchaseAgreementId)
            .identity
            .seller
            .coSeller;

        // Get NFT owner.
        address nftOwner = ownerOf(_tokenId);

        /* PERFORM ASSERTIONS AND RETURN CONFIRMERS */

        if (coSeller != address(0)) {
            return [address(notary()), nftOwner, coSeller];
        } else {
            return [address(notary()), nftOwner, address(0)];
        }
    }
}
