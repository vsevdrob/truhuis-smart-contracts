// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

interface ITruhuisAddressRegistry {
    function auction() external view returns (address);
    function citizen(address _citizen) external view returns (address);
    function currencyRegistry() external view returns (address);
    function stateGovernment(bytes3 _country) external view returns (address);
    function cadastre() external view returns (address);
    function marketplace() external view returns (address);
}
