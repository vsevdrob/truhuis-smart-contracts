// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

/// @notice Municipality struct.
/// @notice Avoid DeclarationError by naming it MunicipalityStruct
struct MunicipalityStruct {
    address contractAddr;
    bool isRegistered;
    uint16 cbsCode;
}

interface ITruhuisAddressRegistry {
    /// @notice Reverted if auction update fails.
    error AuctionUpdateFailed();

    /// @notice Reverted if bank update fails.
    error BankUpdateFailed();

    /// @notice Reverted if cadastre update fails.
    error CadastreUpdateFailed();

    /// @notice Reverted if currency registry update fails.
    error CurrencyRegistryUpdateFailed();

    /// @notice Reverted if tax administration update fails.
    error TaxAdministrationUpdateFailed();

    /// @notice Reverted if marketplace update fails.
    error MarketplaceUpdateFailed();

    /// @notice Reverted if municipality registration fails.
    error MunicipalityRegistrationFailed();

    /// @notice Reverted if municipality update fails.
    error MunicipalityUpdateFailed();

    /// @notice Reverted if personal records database update fails.
    error PersonalRecordsDatabaseUpdateFailed();

    /// @notice Event emitted when an auction update occurs.
    event AuctionUpdated(address newContractAddr);

    /// @notice Event emitted when bank update occurs.
    event BankUpdated(address newContractAddr);

    /// @notice Event emitted when a cadastre update occurs.
    event CadastreUpdated(address newContractAddr);

    /// @notice Event emitted when a currency registry update occurs.
    event CurrencyRegistryUpdated(address newContractAddr);

    /// @notice Event emitted when a marketplace update occurs.
    event MarketplaceUpdated(address newContractAddr);

    /// @notice Event emitted when a municipality registration occurs.
    event MunicipalityRegistered(address contractAddr, uint16 cbsCode);

    /// @notice Event emitted when a municipality update occurs.
    event MunicipalityUpdated(address newContractAddr, uint16 municipality);

    /// @notice Event emitted when a personal records database update occurs.
    event PersonalRecordsDatabaseUpdated(address newContractAddr);

    /// @notice Event emitted when a tax administration update occurs.
    event TaxAdministrationUpdated(address newContractAddr);

    /// @notice Register a supported state government smart contract.
    /// @param _contractAddr Smart contract address of the state government.
    /// @param _cbsCode Country in the form of ISO 3166-1 Alpha-3 code (e.g. "NLD" or "BEL")
    ///        to which the state government belongs.
    ///
    /// Requirements:
    ///
    /// - Can only be called by the current owner.
    /// - `_contractAddr` cannot be the current state government `contractAddr`.
    /// - `_contractAddr` cannot be the zero address.
    ///
    ///
    /// Emits a {MunicipalityRegistered} event.
    ///
    function registerMunicipality(address _contractAddr, uint16 _cbsCode)
        external;

    /// @notice Update Truhuis Auction smart contract address.
    /// @param _auction The new Truhuis Auction smart contract address.
    ///
    /// Requirements:
    ///
    /// - Can only be called by the current owner.
    /// - `_auction` cannot be the current `auction`.
    /// - `_auction` cannot be the zero address.
    ///
    /// Emits a {AuctionUpdated} event.
    ///
    function updateAuction(address _auction) external;

    /// @notice Update Truhuis Bank smart contract address.
    /// @param _bank The new Truhuis Bank smart contract address.
    ///
    /// Requirements:
    ///
    /// - Can only be called by the current owner.
    /// - `_bank` cannot be the current `bank`.
    /// - `_bank` cannot be the zero address.
    ///
    /// Emits a {BankUpdated} event.
    ///
    function updateBank(address _bank) external;

    /// @notice Update Truhuis Cadastre smart contract address.
    /// @param _cadastre The new Truhuis Cadastre smart contract address.
    ///
    /// Requirements:
    ///
    /// - Can only be called by the current owner.
    /// - `_cadastre` cannot be the current `cadastre`.
    /// - `_cadastre` cannot be the zero address.
    ///
    /// Emits a {CadastreUpdated} event.
    ///
    function updateCadastre(address _cadastre) external;

    /// @notice Update Truhuis Currency Registry smart contract address.
    /// @param _currencyRegistry The new Truhuis Currency Registry smart contract address.
    ///
    /// Requirements:
    ///
    /// - Can only be called by the current owner.
    /// - `_currencyRegistry` cannot be the current `currencyRegistry`.
    /// - `_currencyRegistry` cannot be the zero address.
    ///
    /// Emits a {CurrencyRegistryUpdated} event.
    ///
    function updateCurrencyRegistry(address _currencyRegistry) external;

    function updatePersonalRecordsDatabase(address _personalRecordsDatabase)
        external;

    /// @notice Update Internal Revenue Service (IRS) smart contract address.
    function updateTaxAdministration(address _newContractAddr) external;

    /// @notice Update Truhuis Marketplace smart contract address.
    /// @param _marketplace The new Truhuis Marketplace smart contract address.
    ///
    /// Requirements:
    ///
    /// - Can only be called by the current owner.
    /// - `_marketplace` cannot be the current `marketplace`.
    /// - `_marketplace` cannot be the zero address.
    ///
    /// Emits a {MarketplaceUpdated} event.
    ///
    function updateMarketplace(address _marketplace) external;

    /// @notice Update state government smart contract address.
    /// @param _newContractAddr The new state government smart contract address.
    /// @param _cbsCode Country in the form of ISO 3166-1 Alpha-3 code (e.g. "NLD" or "BEL")
    ///        to which the state government belongs.
    ///
    /// Requirements:
    ///
    /// - Can only be called by the current owner.
    /// - `_newContractAddr` cannot be the current state government `contractAddr`.
    /// - `_newContractAddr` cannot be the zero address.
    ///
    /// Emits a {MunicipalityUpdated} event.
    ///
    function updateMunicipality(address _newContractAddr, uint16 _cbsCode)
        external;

    /// @notice Truhuis Auction contract address.
    function auction() external view returns (address);

    /// @notice Truhuis Bank contract address.
    function bank() external view returns (address);

    /// @notice Truhuis Cadastre contract address.
    function cadastre() external view returns (address);

    /// @notice Truhuis Currency Registry contract address.
    function currencyRegistry() external view returns (address);

    /// @notice Truhuis Marketplace contract address.
    function marketplace() external view returns (address);

    /// @notice Personal Records Database contract address.
    function personalRecordsDatabase() external view returns (address);

    /// @notice Tax Administration contract address.
    function taxAdministration() external view returns (address);

    /// @notice Returns a state government smart contract address that
    ///         belogns to the specified country.
    function getMunicipalityContractAddr(uint16 _cbsCode)
        external
        view
        returns (address);

    function isRegisteredMunicipality(address _municipality, uint16 _cbsCode)
        external
        view
        returns (bool);
}
