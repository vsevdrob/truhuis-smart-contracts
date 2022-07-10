// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

interface ICurrencyRegistry {
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
