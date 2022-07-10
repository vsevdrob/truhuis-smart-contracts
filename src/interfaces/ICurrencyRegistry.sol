// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

error CURRENCY_ALREADY_REGISTERED();
error CURRENCY_NOT_REGISTERED();

interface ICurrencyRegistry {
    /// @dev Event emitted whenever a new currency has been registered.
    event CurrencyRegistered(address tokenAddr);
    /// @dev Event emitted whenever a registered currency has been unregistered.
    event CurrencyUnregistered(address tokenAddr);

    /**
     * @dev _
     */
    function registerCurrency(address _tokenAddr) external;

    /**
     * @dev _
     */
    function unregisterCurrency(address _tokenAddr) external;

    /**
     * @dev _
     */
    function isAllowedCurrency(address _token) external view returns (bool);

    /**
     * @dev _
     */
    function isRegisteredCurrency(address _token) external view returns (bool);
}
