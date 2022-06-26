// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./AbstractTruhuisCadastre.sol";
import "../../interfaces/ITruhuisCadastre.sol";

/**
 * @title TruhuisCadastre
 * @author vsevdrob
 * @notice _
 */
contract TruhuisCadastre is AbstractTruhuisCadastre, ITruhuisCadastre {
    constructor(address _addressRegistry, string memory _contractURI)
        ERC721("Truhuis Cadastre", "TCA")
    {
        _sContractURI = _contractURI;
        updateAddressRegistry(_addressRegistry);
    }

    /// @inheritdoc ITruhuisCadastre
    function allotTokenURI(string memory _tokenURI, uint256 _tokenId)
        external
        onlyOwner
    {
        _allotTokenURI(_tokenURI, _tokenId);
    }

    /// @inheritdoc ITruhuisCadastre
    function confirmTransfer(uint256 _tokenId, uint256 _txId)
        external
        onlyPermitted(_tokenId)
    {
        _confirmTransaction(_tokenId, _txId);
    }

    /// @inheritdoc ITruhuisCadastre
    function pause() external onlyOwner {
        _pause();
    }

    /// @inheritdoc ITruhuisCadastre
    function produceNFT(address _to, string memory _tokenURI)
        external
        onlyOwner
    {
        _produceNFT(_to, _tokenURI);
    }

    /// @inheritdoc ITruhuisCadastre
    function submitTransfer(uint256 _tokenId) external onlyNFTOwner(_tokenId) {
        _submitTransaction(_tokenId);
    }

    /// @inheritdoc ITruhuisCadastre
    function revokeTransferConfirmation(uint256 _tokenId, uint256 _txId)
        external
        onlyPermitted(_tokenId)
    {
        _revokeConfirmation(_tokenId, _txId);
    }

    /// @inheritdoc ITruhuisCadastre
    function transferNFTOwnership(
        address _from,
        address _to,
        bytes memory _data,
        uint256 _tokenId,
        uint256 _txId
    ) external onlyNFTOwner(_tokenId) {
        _transferNFTOwnership(_from, _to, _data, _tokenId, _txId);
    }

    /// @inheritdoc ITruhuisCadastre
    function unpause() external onlyOwner {
        _unpause();
    }

    /// @inheritdoc ITruhuisCadastre
    function updateContractURI(string memory _contractURI) external onlyOwner {
        _updateContractURI(_contractURI);
    }

    /// @inheritdoc ITruhuisCadastre
    function exists(uint256 _tokenId) external view returns (bool) {
        return _exists(_tokenId);
    }

    /// @inheritdoc ITruhuisCadastre
    function isNFTOwner(address _account, uint256 _tokenId)
        external
        view
        override
        returns (bool)
    {
        return _isNFTOwner(_account, _tokenId);
    }
}
