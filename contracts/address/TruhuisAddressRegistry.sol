// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./TruhuisAddressRegistryGovernment.sol";

contract TruhuisAddressRegistry is Ownable, TruhuisAddressRegistryGovernment {
    //// Potential addresses
    //address public appraiser;
    //address public bank;
    //address public homeInspector;
    //address public notary;
    //address public mortgagee;

    address public auction;
    address public currencyRegistry;
    address public landRegistry;
    address public marketplace;

    function updateAuction(address _auction) external onlyOwner {
        auction = _auction;
    }

    function updateCurrencyRegistry(address _currencyRegistry) external onlyOwner {
        currencyRegistry = _currencyRegistry;
    }

    function updateLandRegistry(address _landRegistry) external onlyOwner {
        landRegistry = _landRegistry;
    }

    function updateMarketplace(address _marketplace) external onlyOwner {
        marketplace = _marketplace;
    }

    /**
     * @param _country Country ISO 3166-1 Alpha-3 code (e.g. "NLD" or "DEU").
     */
    function government(string memory _country) external view returns (address) {
        return s_governments[bytes3(bytes(_country))].government;
    }
}
