// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./TruhuisAddressRegistryStateGovernment.sol";

contract TruhuisAddressRegistry is Ownable, TruhuisAddressRegistryStateGovernment {

    /// @dev Potential future roles
    //address public appraiser;
    //address public bank;
    //address public homeInspector;
    //address public mortgagee;

    address public auction;
    address public currencyRegistry;
    address public cadastre;
    address public marketplace;

    event AuctionUpdated(
        address indexed oldAddr,
        address indexed newAddr
    );

    event CurrencyRegistryUpdated(
        address indexed oldAddr,
        address indexed newAddr
    );

    event CadastreUpdated(
        address indexed oldAddr,
        address indexed newAddr
    );

    event MarketplaceUpdated(
        address indexed oldAddr,
        address indexed newAddr
    );

    function updateAuction(address _auction) external onlyOwner {
        address oldAddr = auction;
        auction = _auction;
        emit AuctionUpdated(oldAddr, _auction);
    }

    function updateCurrencyRegistry(address _currencyRegistry) external onlyOwner {
        address oldAddr = currencyRegistry;
        currencyRegistry = _currencyRegistry;
        emit CurrencyRegistryUpdated(oldAddr, _currencyRegistry);
    }

    function updateCadastre(address _cadastre) external onlyOwner {
        address oldAddr = cadastre;
        cadastre = _cadastre;
        emit CadastreUpdated(oldAddr, _cadastre);
    }

    function updateMarketplace(address _marketplace) external onlyOwner {
        address oldAddr = marketplace;
        marketplace = _marketplace;
        emit MarketplaceUpdated(oldAddr, _marketplace);
    }

    /**
     * @param _country Country ISO 3166-1 Alpha-3 code (e.g. "NLD" or "DEU").
     */
    function stateGovernment(bytes3 _country) external view returns (address) {
        return s_stateGovernments[_country].stateGovernment;
    }
}
