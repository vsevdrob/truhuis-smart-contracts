// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../resident/Resident.sol";

/*
 * @title   StateGovernment is a contract for storing and retrieving identity information
 *          in the most decentralized way.
 *
 * TODO:    Store all the values in encrypted form.
 * TODO:    Make view functions payable for non official accounts and restrict who
 *          is allowed to ask for the identity information.
 */
contract StateGovernment is Ownable {
    struct ResidentContract {
        bool isRegistered;
        address contractAddr;
    }

    uint96 internal s_transferTax; // e.g. 100 (1%); 1000 (10%)
    uint32 internal s_coolingOffPeriod; // usually 3 days. Consumer rights.

    /// @dev resident addr => resident profile contract
    mapping(address => ResidentContract) internal s_residents;
    bytes3 internal s_country;
    
    event ResidentRegistered(address resident);
    event UpdatedTransferTax(uint256 tax);
    event UpdatedCoolingOffPeriod(uint256 coolingOffPeriod);

    constructor(
        bytes3 _country,
        uint96 _transferTax,
        uint32 _coolingOffPeriod
    ) {
        s_country = _country;
        s_transferTax = _transferTax;
        s_coolingOffPeriod = _coolingOffPeriod;
    }

    function registerResident(
        bytes32[] memory _name,
        uint24[] memory _dateOfBirth,
        bytes32[] memory _placeOfBirth,
        address[] memory _account,
        string[] memory _uri,
        bytes3[] memory _residencies,
        bytes3[] memory _citizenship,
        uint256 _residentialNftId
    ) external onlyOwner {
        Resident resident = new Resident(
            _name,
            _dateOfBirth,
            _placeOfBirth,
            _account,
            _uri,
            _residencies,
            _citizenship,
            _residentialNftId
        );

        s_residents[_account[0]].contractAddr = address(resident);
        s_residents[_account[0]].isRegistered = true;

        emit ResidentRegistered(_account[0]);
    }

    function updateCoolingOffPeriod(uint32 _coolingOffPeriod) external onlyOwner {
        s_coolingOffPeriod = _coolingOffPeriod;
        emit UpdatedCoolingOffPeriod(_coolingOffPeriod);
    }

    function updateTransferTax(uint96 _tax) external onlyOwner {
        s_transferTax = _tax;
        emit UpdatedTransferTax(_tax);
    }

    function getStateGovernmentAddress() public view returns (address) {
        return address(this);
    }

    function getResidentContractAddress(address _resident) public view returns (address) {
        return s_residents[_resident].contractAddr;
    }

    function getCoolingOffPeriod() public view returns (uint32) {
        return s_coolingOffPeriod;
    }

    function getStateGovernmentCountry() public view returns (bytes3) {
        return s_country;
    }

    function getTransferTax() public view returns (uint96) {
        return s_transferTax;
    }

    function isResidentRegistered(address _resident) public view returns (bool) {
        return s_residents[_resident].isRegistered;
    }
}
