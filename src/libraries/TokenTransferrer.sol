// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@core/addresser/TruhuisAddresserAPI.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error ERC20TransferFailed();
error ERC721TransferFailed();

/**
 * @title TokenTransferrer
 * @author vsevdrob
 * @notice TokenTransferrer is library for performing ERC20 and ERC721
 *         transfers, used by Truhuis Bank Truhuis Marketplace and Truhuis
 *         Auction.
 */
contract TokenTransferrer is TruhuisAddresserAPI {
    function _performERC20Transfer(
        address _to,
        address _token,
        uint256 _amount
    ) internal virtual {
        if (!IERC20(_token).transfer(_to, _amount)) {
            revert ERC20TransferFailed();
        }
    }

    /**
     * @dev Internal function to transfer ERC20 tokens from a given originator
     *      to a given recipient. Sufficient approvals must be set on the
     *      contract performing the transfer.
     *
     * @param _from   The originator of the transfer.
     * @param _to     The recipient of the transfer.
     * @param _token  The ERC20 token to transfer.
     * @param _amount The amount to transfer.
     */
    function _performERC20TransferFrom(
        address _from,
        address _to,
        address _token,
        uint256 _amount
    ) internal virtual {
        if (!IERC20(_token).transferFrom(_from, _to, _amount)) {
            revert ERC20TransferFailed();
        }
    }

    /**
     * @dev Internal function to transfer an ERC721 token from a given
     *      originator to a given recipient. Sufficient approvals must be set on
     *      the contract performing the transfer. Note that this function does
     *      check whether the receiver can accept the ERC721 token (i.e. it
     *      does use `safeTransferFrom`).
     *
     * @param _from    The originator of the transfer.
     * @param _to      The recipient of the transfer.
     * @param _tokenId The NFT to transfer.
     */
    function _performERC721Transfer(
        address _from,
        address _to,
        bytes memory _data,
        uint256 _tokenId,
        uint256 _txId
    ) internal virtual {
        cadastre().transferNFTOwnership(_from, _to, _data, _tokenId, _txId);

        if (cadastre().ownerOf(_tokenId) != _to) {
            revert ERC721TransferFailed();
        }
    }

    /**
     * @dev _
     */
    function _getERC20Balance(address _currency)
        internal
        view
        returns (uint256)
    {
        return IERC20(_currency).balanceOf(address(this));
    }
}
