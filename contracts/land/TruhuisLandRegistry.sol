// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "../address/adapters/TruhuisAddressRegistryAdapter.sol";
import "../../interfaces/IGovernment.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

error ProvidedIdenticalTokenUriError(uint256 tokenId, string tokenURI);
error NotOwnerError(address account, uint256 tokenId);

contract TruhuisLandRegistry is 
    ERC721,
    Ownable,
    Pausable,
    ERC721Royalty,
    ERC721Burnable,
    ERC721URIStorage,
    ERC721Enumerable,
    TruhuisAddressRegistryAdapter
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    string public contractURI;

    constructor(
        string memory _contractURI,
        address _addressRegistry
    ) ERC721("Truhuis Land Registry", "TLR") {
        contractURI = _contractURI;
        _updateAddressRegistry(_addressRegistry);
        //_setDefaultRoyalty(address(this), 100);
    }

    event Minted(address to, uint256 tokenId, string tokenURI, address transferTaxReceiver, uint256 transferTaxFraction);
    event SetTokenURI(uint256 tokenId, string _tokenURI);
    event SetDefaultRoyalty(address receiver, uint96 fraction);
    event SetTokenRoyalty(uint256 tokenId, address receiver, uint96 fraction);
    event DeletedDefaultRoyalty();
    event ResetTokenRoyalty(uint256 tokenId);

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

    function pause() external onlyOwner {_pause();}

    function unpause() external onlyOwner {_unpause();}

    function setContractURI(string memory _contractURI) external onlyOwner {
        contractURI = _contractURI;
    }

    function safeMint(address _to, string memory _tokenURI, string memory _realEstateCountry)
        public
        onlyOwner
        isValidTokenURI(_tokenIdCounter.current(), _tokenURI)
    {
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        address transferTaxReceiver = government(_realEstateCountry).getAddress();
        uint96 transferTax = government(_realEstateCountry).getTransferTax(); 

        _setTokenRoyalty(tokenId, transferTaxReceiver, transferTax);

        setApprovalForAll(address(auction()), true);
        setApprovalForAll(address(marketplace()), true);

        emit Minted(msg.sender, tokenId, _tokenURI, transferTaxReceiver, transferTax);
    }

    function setTokenURI(uint256 _tokenId, string memory _tokenURI)
        public
        onlyOwner
        isValidTokenURI(_tokenId, _tokenURI)
    {
        _setTokenURI(_tokenId, _tokenURI);
        emit SetTokenURI(_tokenId, _tokenURI);
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator)
        public
        onlyOwner
    {
        _setDefaultRoyalty(_receiver, _feeNumerator);
        emit SetDefaultRoyalty(_receiver, _feeNumerator);
    }

    function setTokenRoyalty(
        uint256 _tokenId,
        address _receiver,
        uint96 _feeNumerator
    ) 
        public
        onlyOwner
    {
        _setTokenRoyalty(_tokenId, _receiver, _feeNumerator);
        emit SetTokenRoyalty(_tokenId, _receiver, _feeNumerator);
    }

    function deleteDefaultRoyalty() public onlyOwner {
        _deleteDefaultRoyalty();
        emit DeletedDefaultRoyalty();
    }

    function resetTokenRoyalty(uint256 _tokenId)
        public
        onlyOwner
    {
        _resetTokenRoyalty(_tokenId);
        emit ResetTokenRoyalty(_tokenId);
    }

    function isOwner(address _account, uint256 _tokenId) public view returns (bool) {
        return (_account == ownerOf(_tokenId) ? true : false);
    }

    function _validatePropertyOwner(address _account, uint256 _tokenId) internal view {
        if (!isOwner(_account, _tokenId)) revert NotOwnerError(_account, _tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage, ERC721Royalty)
    {
        require(_exists(tokenId), "Token ID set of nonexistent token.");
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
    
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721Royalty)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}


