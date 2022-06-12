// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Truhuis Address Registry smart contract.
/// @notice This contract deployed in order to implement parameterization method
///         of upgradable smart contracts by performing addresses registry.
contract TruhuisAddressRegistry is Ownable {
    /// @notice Reverted if an auction update fails.
    error TruhuisAddressRegistry__AuctionUpdateFailed();
    /// @notice Reverted if a cadastre update fails.
    error TruhuisAddressRegistry__CadastreUpdateFailed();
    /// @notice Reverted if a currency registry update fails.
    error TruhuisAddressRegistry__CurrencyRegistryUpdateFailed();
    /// @notice Reverted if a marketplace update fails.
    error TruhuisAddressRegistry__MarketplaceUpdateFailed();
    /// @notice Reverted if a state government registration fails.
    error TruhuisAddressRegistry__StateGovernmentRegistrationFailed(); 
    /// @notice Reverted if a state government update fails.
    error TruhuisAddressRegistry__StateGovernmentUpdateFailed();

    /// @notice State government struct.
    struct StateGovernment {
        address contractAddr;
        bool isRegistered;
        bytes3 country;
    }

    /// @notice Truhuis Auction contract address.
    address public auction;
    /// @notice Truhuis Cadastre contract address.
    address public cadastre;
    /// @notice Truhuis Currency Registry contract address.
    address public currencyRegistry;
    /// @notice Truhuis Marketplace contract address.
    address public marketplace;

    /// @notice State government country => State sovernment struct
    mapping(bytes3 => StateGovernment) public s_stateGovernments;

    /// @notice Event emitted when an auction update occurs.
    event AuctionUpdated(
        address newContractAddr
    );

    /// @notice Event emitted when a cadastre update occurs.
    event CadastreUpdated(
        address newContractAddr
    );

    /// @notice Event emitted when a currency registry update occurs.
    event CurrencyRegistryUpdated(
        address newContractAddr
    );

    /// @notice Event emitted when a marketplace update occurs.
    event MarketplaceUpdated(
        address newContractAddr
    );

    /// @notice Event emitted when a state government registration occurs.
    event StateGovernmentRegistered(
        address contractAddr,
        bytes3 country
    );

    /// @notice Event emitted when a state government update occurs.
    event StateGovernmentUpdated(
        address newContractAddr,
        bytes3 country
    );

    /// @notice Register a supported state government smart contract.
    /// @param _contractAddr Smart contract address of the state government.
    /// @param _country Country in the form of ISO 3166-1 Alpha-3 code (e.g. "NLD" or "BEL")
    ///        to which the state government belongs.
    function registerStateGovernment(address _contractAddr, bytes3 _country)
        external
        onlyOwner
    {
        StateGovernment storage s_stateGovernment = s_stateGovernments[_country];

        if (
            _contractAddr == address(0)
            || s_stateGovernment.contractAddr == _contractAddr
            || s_stateGovernment.isRegistered == true
            || s_stateGovernment.country == _country
        ) {
            revert TruhuisAddressRegistry__StateGovernmentRegistrationFailed();
        }

        s_stateGovernment.contractAddr = _contractAddr;
        s_stateGovernment.isRegistered = true;
        s_stateGovernment.country = _country;

        emit StateGovernmentRegistered(_contractAddr, _country);
    }

    /// @notice Update Truhuis Auction smart contract address.
    /// @param _auction The new Truhuis Auction smart contract address.
    /// @dev Only owner is able to call this function.
    function updateAuction(address _auction) external onlyOwner {
        if (auction == _auction) {
            revert TruhuisAddressRegistry__AuctionUpdateFailed();
        }

        auction = _auction;
        emit AuctionUpdated(_auction);
    }

    /// @notice Update Truhuis Cadastre smart contract address.
    /// @param _cadastre The new Truhuis Cadastre smart contract address.
    /// @dev Only owner is able to call this function.
    function updateCadastre(address _cadastre) external onlyOwner {
        if (cadastre == _cadastre) {
            revert TruhuisAddressRegistry__CadastreUpdateFailed();
        }

        cadastre = _cadastre;
        emit CadastreUpdated(_cadastre);
    }

    /// @notice Update Truhuis Currency Registry smart contract address.
    /// @param _currencyRegistry The new Truhuis Currency Registry smart contract address.
    /// @dev Only owner is able to call this function.
    function updateCurrencyRegistry(address _currencyRegistry) external onlyOwner {
        if (currencyRegistry == _currencyRegistry) {
            revert TruhuisAddressRegistry__CurrencyRegistryUpdateFailed();
        }

        currencyRegistry = _currencyRegistry;
        emit CurrencyRegistryUpdated(_currencyRegistry);
    }

    /// @notice Update Truhuis Marketplace smart contract address.
    /// @param _marketplace The new Truhuis Marketplace smart contract address.
    /// @dev Only owner is able to call this function.
    function updateMarketplace(address _marketplace) external onlyOwner {
        if (marketplace == _marketplace) {
            revert TruhuisAddressRegistry__MarketplaceUpdateFailed();
        }

        marketplace = _marketplace;
        emit MarketplaceUpdated(_marketplace);
    }

    /// @notice Update state government smart contract address.
    /// @param _newContractAddr The new state government smart contract address.
    /// @param _country Country in the form of ISO 3166-1 Alpha-3 code (e.g. "NLD" or "BEL")
    ///        to which the state government belongs.
    /// @dev Only owner is able to call this function.
    function updateStateGovernment(address _newContractAddr, bytes3 _country)
        external
        onlyOwner
    {
        StateGovernment storage s_stateGovernment = s_stateGovernments[_country];

        if (s_stateGovernment.contractAddr == _newContractAddr) {
            revert TruhuisAddressRegistry__StateGovernmentUpdateFailed();
        }

        s_stateGovernment.contractAddr = _newContractAddr;

        emit StateGovernmentUpdated(_newContractAddr, _country);
    }

    /// @notice Returns a state government smart contract address that
    ///         belogns to the specified country.
    ///
    /// @param _country Country in the form of ISO 3166-1 Alpha-3 code (e.g. "NLD" or "BEL")
    ///        to which the state government belongs.
    function getStateGovernmentContractAddr(bytes3 _country) external view returns (address) {
        return s_stateGovernments[_country].contractAddr;
    }
}
