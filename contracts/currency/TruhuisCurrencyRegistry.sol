// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

error CurrencyAlreadyImplemented();
error NonExistentCurrencyError();

/// @title ERC20 token addresses with which user pays during purchase.
contract TruhuisCurrencyRegistry is Ownable {

    /// @notice Mapping of allowed ERC20 currencies.
    /// @return Boolean true (allowed) or false (disallowed).
    mapping(address => bool) public s_allowed;

    /// @dev Event - implemented new ERC20 token.
    event Added(address _tokenAddr);
    /// @dev Event - disallowed and removed ERC20 token.
    event Removed(address _tokenAddr);

    /// @notice Add ERC20 as the new currency.
    /// @dev Only owner.
    /// @param _tokenAddr ERC20 token address.
    function add(address _tokenAddr) external onlyOwner {
        if (s_allowed[_tokenAddr]) revert CurrencyAlreadyImplemented();
        s_allowed[_tokenAddr] = true;
        emit Added(_tokenAddr);
    }

    /// @notice Remove added ERC20 token from allowed payment resources.
    /// @dev Only owner.
    /// @param _tokenAddr ERC20 token address.
    function remove(address _tokenAddr) external onlyOwner {
        if (!s_allowed[_tokenAddr]) revert NonExistentCurrencyError();
        s_allowed[_tokenAddr] = false;
        emit Removed(_tokenAddr);
    }

    function isAllowed(address _tokenAddr) external view returns (bool) {
        return s_allowed[_tokenAddr];
    }
}

