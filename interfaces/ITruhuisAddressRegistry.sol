// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

interface ITruhuisAddressRegistry {
    function auction() external view returns (address);
    function citizen(address _account) external view returns (address);
    function currencyRegistry() external view returns (address);
    function government(string memory _country) external view returns (address);
    function landRegistry() external view returns (address);
    function marketplace() external view returns (address);
}
