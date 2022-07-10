// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@interfaces/ICurrencyRegistry.sol";

error CURRENCY_ALREADY_REGISTERED();
error CURRENCY_NOT_REGISTERED();

/**
 * @title CurrencyRegistry
 * @author vsevdrob
 * @notice _
 */
abstract contract ACurrencyRegistry is ICurrencyRegistry {
    mapping(address => bool) private _sIsRegistered;

    event CurrencyRegistered(address tokenAddr);
    event CurrencyUnregistered(address tokenAddr);

    /// @inheritdoc ICurrencyRegistry
    function isAllowedCurrency(address _tokenAddr)
        external
        view
        override
        returns (bool)
    {
        return _sIsRegistered[_tokenAddr];
    }

    /// @inheritdoc ICurrencyRegistry
    function isRegisteredCurrency(address _tokenAddr)
        external
        view
        override
        returns (bool)
    {
        return _sIsRegistered[_tokenAddr];
    }

    /**
     * @dev _
     */
    function _registerCurrency(address _tokenAddr) internal {
        /* PERFORM ASSERTIONS */

        // Currency must be not already registered.
        if (_sIsRegistered[_tokenAddr]) {
            revert CURRENCY_ALREADY_REGISTERED();
        }

        /* REGISTER CURRENCY */

        _sIsRegistered[_tokenAddr] = true;

        // Emit a {CurrencyRegistered} event.
        emit CurrencyRegistered(_tokenAddr);
    }

    /**
     * @dev _
     */
    function _unregisterCurrency(address _tokenAddr) internal {
        /* PERFORM ASSERTIONS */

        // Currency must be registered.
        if (!_sIsRegistered[_tokenAddr]) {
            revert CURRENCY_NOT_REGISTERED();
        }

        /* UNREGISTER CURRENCY */

        _sIsRegistered[_tokenAddr] = false;

        // Emit a {CurrencyUnregistered} event.
        emit CurrencyUnregistered(_tokenAddr);
    }
}
