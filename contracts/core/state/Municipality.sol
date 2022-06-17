// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../../libraries/Signature.sol";
import "../../interfaces/IMunicipality.sol";
import "../address/TruhuisAddressRegistryAdapter.sol";
import {MunicipalityStorage as Storage} from "./MunicipalityStorage.sol";

/*
 * @title   StateGovernment is a contract for storing and retrieving identity information
 *          in the most decentralized way.
 *
 * TODO:    Store all the values in encrypted form.
 * TODO:    Make view functions payable for non official accounts and restrict who
 *          is allowed to ask for the identity information.
 */
abstract contract Municipality is
    Ownable,
    IMunicipality,
    Storage,
    TruhuisAddressRegistryAdapter
{
    //function updateCoolingOffPeriod(uint32 _coolingOffPeriod) external override onlyOwner {
    //    s_coolingOffPeriod = _coolingOffPeriod;
    //    emit UpdatedCoolingOffPeriod(_coolingOffPeriod);
    //}
    //function getStateGovernmentAddress() public view override returns (address) {
    //    return address(this);
    //}
    //function getResidentContractAddress(address _resident) public view override returns (address) {
    //    return s_residents[_resident].contractAddr;
    //}
    //function getCoolingOffPeriod() public view override returns (uint32) {
    //    return s_coolingOffPeriod;
    //}
    //function getStateGovernmentCountry() public view override returns (bytes3) {
    //    return s_country;
    //}
    //function isResidentRegistered(address _resident) public view override returns (bool) {
    //    return s_residents[_resident].isRegistered;
    //}
}
