// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../../interfaces/ITruhuisAddressRegistry.sol";
import {TruhuisAddressRegistryStorage as Storage} from "./TruhuisAddressRegistryStorage.sol";

/// @title Truhuis Address Registry smart contract.
/// @notice This contract deployed in order to implement parameterization method
///         of upgradable smart contracts by performing addresses registry.
abstract contract TruhuisAddressRegistry is Ownable, Storage, ITruhuisAddressRegistry {
    /// @inheritdoc ITruhuisAddressRegistry
    function registerMunicipality(address _contractAddr, uint16 _cbsCode)
        external
        override
        onlyOwner
    {
        Municipality storage s_municipality = _sMunicipalities[_cbsCode];

        if (
            _contractAddr == address(0)
            || s_municipality.contractAddr == _contractAddr
            || s_municipality.isRegistered == true
            || s_municipality.cbsCode == _cbsCode
        ) revert MunicipalityRegistrationFailed();

        s_municipality.contractAddr = _contractAddr;
        s_municipality.isRegistered = true;
        s_municipality.cbsCode = _cbsCode;

        emit MunicipalityRegistered(_contractAddr, _cbsCode);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function updateAuction(address _auction) external override onlyOwner {
        if (_sAuction == _auction || _auction == address(0)) 
            revert AuctionUpdateFailed();

        _sAuction = _auction;
        emit AuctionUpdated(_auction);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function updateBank(address _bank) external override onlyOwner {
        if (_sBank == _bank || _bank == address(0))
            revert BankUpdateFailed();

        _sBank = _bank;
        emit BankUpdated(_bank);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function updateCadastre(address _cadastre) external override onlyOwner {
        if (_sCadastre == _cadastre || _cadastre == address(0))
            revert CadastreUpdateFailed();

        _sCadastre = _cadastre;
        emit CadastreUpdated(_cadastre);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function updateCurrencyRegistry(address _currencyRegistry) external override onlyOwner {
        if (_sCurrencyRegistry == _currencyRegistry || _currencyRegistry == address(0))
            revert CurrencyRegistryUpdateFailed();

        _sCurrencyRegistry = _currencyRegistry;
        emit CurrencyRegistryUpdated(_currencyRegistry);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function updateMarketplace(address _marketplace) external override onlyOwner {
        if (_sMarketplace == _marketplace || _marketplace == address(0))
            revert MarketplaceUpdateFailed();

        _sMarketplace = _marketplace;
        emit MarketplaceUpdated(_marketplace);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function updateMunicipality(address _newContractAddr, uint16 _cbsCode)
        external
        override
        onlyOwner
    {
        Municipality storage s_municipality = _sMunicipalities[_cbsCode];

        if (
            s_municipality.contractAddr == _newContractAddr
            || _newContractAddr == address(0)
        ) {
            revert MunicipalityUpdateFailed();
        }

        s_municipality.contractAddr = _newContractAddr;
        emit MunicipalityUpdated(_newContractAddr, _cbsCode);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function updatePersonalRecordsDatabase(
        address _personalRecordsDatabase
    ) external override onlyOwner {
        if (
            _sPersonalRecordsDatabase == _personalRecordsDatabase
            || _personalRecordsDatabase == address(0)
        ) {
            revert PersonalRecordsDatabaseUpdateFailed();
        }

        _sPersonalRecordsDatabase = _personalRecordsDatabase;
        emit PersonalRecordsDatabaseUpdated(_personalRecordsDatabase);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function updateTaxAdministration(address _newContractAddr)
        external
        override
        onlyOwner
    {
        if (
            _sTaxAdministration == _newContractAddr
            || _newContractAddr == address(0)
        ) {
            revert TaxAdministrationUpdateFailed();
        }

        _sTaxAdministration = _newContractAddr;
        emit TaxAdministrationUpdated(_newContractAddr);
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function auction() external view override returns (address) {
        return _sAuction;
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function bank() external view override returns (address) {
        return _sBank;
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function cadastre() external view override returns (address) {
        return _sCadastre;
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function currencyRegistry() external view override returns (address) {
        return _sCurrencyRegistry;
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function marketplace() external view override returns (address) {
        return _sMarketplace;
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function personalRecordsDatabase() external view override returns (address) {
        return _sPersonalRecordsDatabase;
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function taxAdministration() external view returns (address) {
        return _sTaxAdministration;
    }

    /// @inheritdoc ITruhuisAddressRegistry
    function getMunicipalityContractAddr(uint16 _cbsCode) external view returns (address) {
        return _sMunicipalities[_cbsCode].contractAddr;
    }

    function isRegisteredMunicipality(address _municipality, uint16 _cbsCode)
        external
        view
        returns (bool)
    {
        Municipality memory municipality = _sMunicipalities[_cbsCode];

        if (
            municipality.contractAddr != _municipality
            || !municipality.isRegistered
            || municipality.cbsCode != _cbsCode
        ) {
            return false;
        }

        return true;
    }
}
