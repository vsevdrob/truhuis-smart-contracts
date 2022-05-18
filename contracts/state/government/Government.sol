// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../citizen/Citizen.sol";

contract Government is Ownable {

    mapping(address => address) internal s_citizens; // citizen addr to the citizen profile.
    bytes3 internal s_country;
    
    uint96 internal s_transferTax; // e.g. 100 (1%); 1000 (10%)

    event RegisteredCitizen(address citizen);
    event SetTransferTax(uint256 _tax);

    constructor(
        string memory _country,
        uint96 _transferTax
    ) {
        s_country = bytes3(bytes(_country));
        s_transferTax = _transferTax;
    }

    function registerCitizen(
        bytes32[] memory _name,
        int8[] memory _dateOfBirth,
        bytes32[] memory _placeOfBirth,
        address[] memory _account,
        string[] memory _uri,
        bytes32[] memory _citizenship
    ) external onlyOwner {
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

    function setTransferTax(uint96 _tax) external onlyOwner {
        s_transferTax = _tax;
        emit SetTransferTax(_tax);
    }

    function getAddress() public view returns (address) {
        return address(this);
    }

    function getCitizen(address _citizen) public view returns (address) {
        return s_citizens[_citizen];
    }

    function getCountry() public view returns (string memory) {
        return string(abi.encode(s_country));
    }

    function getTransferTax() public view returns (uint96) {
        return s_transferTax;
    }
}
