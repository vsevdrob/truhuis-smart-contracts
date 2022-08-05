// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

// Reverted if provided token address has been already registered.
error CURRENCY_ALREADY_REGISTERED();
// Reverted if provided token address is not registered.
error CURRENCY_NOT_REGISTERED();

interface ICurrencyRegistry {
    /// @dev Event emitted whenever a new currency has been registered.
    event CurrencyRegistered(address tokenAddr);
    /// @dev Event emitted whenever a registered currency has been unregistered.
    event CurrencyUnregistered(address tokenAddr);

    /**
     * @dev Register new currency in the form of an ERC-20 token address.
     */
    function registerCurrency(address _tokenAddr) external;

    /**
     * @dev Unregister currency.
     */
    function unregisterCurrency(address _tokenAddr) external;

    /**
     * @dev Get whether currency is allowed to be used as payment currency or
     *      not.
     */
    function isAllowedCurrency(address _token) external view returns (bool);

    /**
     * @dev Get whether currency has been registered or not.
     */
    function isRegisteredCurrency(address _token) external view returns (bool);
}
