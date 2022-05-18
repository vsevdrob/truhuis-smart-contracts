// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import { Country } from "./utils/Country.sol";

contract TruhuisAddressRegistryGovernment is Ownable {
    struct Government {
        bool isRegistered;
        address government;
        bytes3 country;
    }

    mapping(bytes3 => Government) public s_governments;

    event GovernmentRegistered(address government, string country);

    modifier notRegisteredGovernemnt(address _government, string calldata _country) {
        bytes3 country = bytes3(bytes(_country));
        Government memory government = s_governments[country];

        require(government.isRegistered == false, "already registered");
        require(government.government != _government, "provided identical government");
        require(government.country != country, "provided identical country");

        _;
    }

    function updateGovernment(address _newAddr, string memory _country)
        public 
        onlyOwner
    {
        s_governments[bytes3(bytes(_country))] = Government({
            isRegistered: true,
            government: _newAddr,
            country: bytes3(bytes(_country))
        });
    }

    function registerGovernment(address _government, string calldata _country)
        public
        onlyOwner
        notRegisteredGovernemnt(_government, _country)
    {
        _registerGovernment(_government, _country);
    }

    function _registerGovernment(address _government, string memory _country)
        private
    {
        require(_government != address(0), "invalid zero address");

        bytes3 country = bytes3(bytes(_country));

        s_governments[country] = Government({
            isRegistered: true,
            government: _government,
            country: country
        });

        emit GovernmentRegistered(_government, _country);
    }
}


