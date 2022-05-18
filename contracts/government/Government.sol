// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Citizen.sol";

contract Government is Ownable {

    mapping(address => address) public s_citizens; // citizen addr to the citizen profile.

    event RegisteredCitizen(address citizen);

    function registerCitizen(
        bytes32[] memory _name,
        int8[] memory _dateOfBirth,
        bytes32[] memory _placeOfBirth,
        address[] memory _account,
        string[] memory _uri,
        bytes32[] memory _citizenship
    ) public onlyOwner {
        Citizen citizenNFT = new Citizen(
            _name,
            _dateOfBirth,
            _placeOfBirth,
            _account,
            _uri,
            _citizenship
        );

        s_citizens[_account[0]] = address(citizenNFT);
        
        emit RegisteredCitizen(_account[0]);
    }

    function getCitizen(address _citizen) public view returns (address) {
        return s_citizens[_citizen];
    }
}
