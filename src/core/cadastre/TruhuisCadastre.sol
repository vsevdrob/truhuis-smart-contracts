// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./ATruhuisCadastre.sol";

/**
 * @title TruhuisCadastre
 * @author vsevdrob
 * @notice _
 */
contract TruhuisCadastre is ATruhuisCadastre {
    constructor(address _addresser, string memory _contractURI)
        ATruhuisCadastre(_addresser, _contractURI)
    {}

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
        _confirmTransfer(_tokenId, _txId);
    }

    /// @inheritdoc ITruhuisCadastre
    function pauseContract() external onlyOwner {
        _pauseContract();
    }

    /// @inheritdoc ITruhuisCadastre
    function produceNFT(address _to, string memory _tokenURI)
        external
        onlyOwner
    {
        _produceNFT(_to, _tokenURI);
    }

    /// @inheritdoc ITruhuisCadastre
    function revokeTransferConfirmation(uint256 _tokenId, uint256 _txId)
        external
        onlyPermitted(_tokenId)
    {
        _revokeTransferConfirmation(_tokenId, _txId);
    }

    /// @inheritdoc ITruhuisCadastre
    function submitTransfer(uint256 _purchaseAgreementId, uint256 _tokenId)
        external
        onlyNFTOwner(_tokenId)
    {
        _submitTransfer(_purchaseAgreementId, _tokenId);
    }

    /// @inheritdoc ITruhuisCadastre
    function transferNFTOwnership(
        address _from,
        address _to,
        bytes memory _data,
        uint256 _tokenId,
        uint256 _txId
    ) external onlyPermitted(_tokenId) {
        _transferNFTOwnership(_from, _to, _data, _tokenId, _txId);
    }

    /// @inheritdoc ITruhuisCadastre
    function unpauseContract() external onlyOwner {
        _unpauseContract();
    }

    /// @inheritdoc ITruhuisCadastre
    function updateContractURI(string memory _contractURI) external onlyOwner {
        _updateContractURI(_contractURI);
    }
}
