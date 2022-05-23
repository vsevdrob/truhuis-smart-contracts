// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../citizen/Citizen.sol";

contract StateGovernment is Ownable {

    struct CitizenContract {
        bool isRegistered;
        address citizenContract;
    }

    /// @dev citizen addr => citizen profile contract
    mapping(address => CitizenContract) internal s_citizens; // citizen addr to the citizen profile.
    bytes3 internal s_country;
    
    uint96 internal s_transferTax; // e.g. 100 (1%); 1000 (10%)
    uint256 internal s_coolingOffPeriod; // usually 3 days. Consumer rights.

    event RegisteredCitizen(address citizen);
    event UpdatedTransferTax(uint256 tax);
    event UpdatedCoolingOffPeriod(uint256 coolingOffPeriod);

    constructor(
        bytes3 _country,
        uint96 _transferTax,
        uint256 _coolingOffPeriod
    ) {
        s_country = _country;
        s_transferTax = _transferTax;
        s_coolingOffPeriod = _coolingOffPeriod;
    }

    //function registerCitizen(address _citizenAccount, address _citizenContract) external onlyOwner {
    //    s_citizens[_citizenAccount].citizen = _citizenContract;
    //    s_citizens[_citizenAccount].exists = true;
    //    
    //    emit RegisteredCitizen(_citizenAccount);
    //}

    function registerCitizen(
        bytes32[] memory _name,
        uint24[] memory _dateOfBirth,
        bytes32[] memory _placeOfBirth,
        address[] memory _account,
        string[] memory _uri,
        bytes3[] memory _citizenship
    ) external onlyOwner {
        Citizen citizenNFT = new Citizen(
            _name,
            _dateOfBirth,
            _placeOfBirth,
            _account,
            _uri,
            _citizenship
        );

        s_citizens[_account[0]].citizenContract = address(citizenNFT);
        s_citizens[_account[0]].isRegistered = true;

        emit RegisteredCitizen(_account[0]);
    }

    function updateCoolingOffPeriod(uint256 _coolingOffPeriod) external onlyOwner {
        s_coolingOffPeriod = _coolingOffPeriod;
        emit UpdatedCoolingOffPeriod(_coolingOffPeriod);
    }

    function updateTransferTax(uint96 _tax) external onlyOwner {
        s_transferTax = _tax;
        emit UpdatedTransferTax(_tax);
    }

    function getAddress() public view returns (address) {
        return address(this);
    }

    function getCitizenContractAddress(address _citizen) public view returns (address) {
        return s_citizens[_citizen].citizenContract;
    }

    function getCoolingOffPeriod() public view returns (uint256) {
        return s_coolingOffPeriod;
    }

    function getCountry() public view returns (bytes3) {
        return s_country;
    }

    function getIsCitizenContractRegistered(address _citizen) public view returns (bool) {
        return s_citizens[_citizen].isRegistered;
    }

    function getTransferTax() public view returns (uint96) {
        return s_transferTax;
    }
}
