// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

/**
 * @title Observes all major changes in reference to a tokenId in marketplace.
 */
contract TokenIdObserver {

    /// @dev tokenIds that are currently for listed
    uint256[] private s_forSaleTokenIds;
    /// @dev Free index of zero value (0) in s_forSaleTokenIds array
    uint256[] private s_freeIndexes;

    /// @dev tokenId => tokenId's index in s_forSaleTokenIds array
    mapping(uint256 => uint256) private _tokenIdIndexes;

    /// @notice Fetch all currently listed houses.
    function fetchListedHouses() public view returns (uint256[] memory) {
        return s_forSaleTokenIds;
    }

    /// @dev Get tokenId index assigned in s_forSaleTokenIds.
    function getTokenIdIndex(uint256 _tokenId) public view returns (uint256) {
        return _tokenIdIndexes[_tokenId];
    }

    /// @dev Called when house is listed.
    function _storeTokenId(uint256 _tokenId) internal {
        uint256 freeIndex = _retrieveFreeIndex();

        if (freeIndex == 0 && s_freeIndexes.length == 0) {
            uint256 nextIndex = s_forSaleTokenIds.length;
            s_forSaleTokenIds.push(_tokenId);
            _tokenIdIndexes[_tokenId] = nextIndex;
        } else {
            s_forSaleTokenIds[freeIndex] = _tokenId;
            _tokenIdIndexes[_tokenId] = freeIndex;

            s_freeIndexes.pop();
        }
    }

    /// @dev Called when house is sold or canceled.
    function _deleteTokenId(uint256 _tokenId) internal {
        uint256 index = _tokenIdIndexes[_tokenId];
        s_freeIndexes.push(index);

        delete s_forSaleTokenIds[index];
        delete _tokenIdIndexes[_tokenId];
    }

    function _retrieveFreeIndex() private view returns (uint256) {
        uint256[] memory freeIndexes = s_freeIndexes;

        if (freeIndexes.length != 0) {
            uint256 lastIndex = freeIndexes[freeIndexes.length - 1];
            return lastIndex;
        } else {
            return 0;
        }
    }
}
