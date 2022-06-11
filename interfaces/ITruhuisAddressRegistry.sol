// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

interface ITruhuisAddressRegistry {
    /// @notice Truhuis Auction contract address.
    function auction() external view returns (address);

    /// @notice Truhuis Cadastre contract address.
    function cadastre() external view returns (address);

    /// @notice Truhuis Currency Registry contract address.
    function currencyRegistry() external view returns (address);

    /// @notice Truhuis Marketplace contract address.
    function marketplace() external view returns (address);

    /// @notice Returns a state government smart contract address that
    ///         belogns to the specified country.
    ///
    /// @param _country Country in the form of ISO 3166-1 Alpha-3 code (e.g. "NLD" or "BEL")
    ///        to which the state government belongs.
    function stateGovernment(bytes3 _country) external view returns (address);
}
