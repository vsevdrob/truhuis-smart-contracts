// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import { Country } from "./utils/Country.sol";

contract TruhuisAddressRegistryStateGovernment is Ownable {
    struct StateGovernment {
        bool isRegistered;
        address stateGovernment;
        bytes3 country;
    }

    mapping(bytes3 => StateGovernment) public s_stateGovernments;

    event StateGovernmentRegistered(address stateGovernment, bytes3 country);
    event UpdatedStateGovernment(address oldAddr, address newAddr, bytes3 country);

    modifier notRegisteredGovernemnt(address _stateGovernment, bytes3 _country) {
        StateGovernment memory stateGov = s_stateGovernments[_country];

        require(stateGov.isRegistered == false, "already registered");
        require(stateGov.stateGovernment != _stateGovernment, "provided identical stateGov");
        require(stateGov.country != _country, "provided identical country");

        _;
    }

    function updateStateGovernment(address _newAddr, bytes3 _country)
        public 
        onlyOwner
    {
        StateGovernment storage s_stateGovernment = s_stateGovernments[_country];

        address oldAddr = s_stateGovernment.stateGovernment;

        require(oldAddr != _newAddr, "provided the same address");

        s_stateGovernment.isRegistered = true;
        s_stateGovernment.stateGovernment = _newAddr;
        s_stateGovernment.country = _country;

        emit UpdatedStateGovernment(oldAddr, _newAddr, _country);
    }

    function registerStateGovernment(address _stateGovernment, bytes3 _country)
        public
        onlyOwner
        notRegisteredGovernemnt(_stateGovernment, _country)
    {
        _registerStateGovernment(_stateGovernment, _country);
    }

    function _registerStateGovernment(address _stateGovernment, bytes3 _country)
        private
    {
        require(_stateGovernment != address(0), "invalid zero address");

        s_stateGovernments[_country] = StateGovernment({
            isRegistered: true,
            stateGovernment: _stateGovernment,
            country: _country
        });

        emit StateGovernmentRegistered(_stateGovernment, _country);
    }
}


