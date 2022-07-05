// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

//import "../address/TruhuisAddressRegistryAdapter.sol";
//import "../../interfaces/IMunicipality.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract AMunicipality {
    bytes4 private _sIdentifier;

    constructor(bytes4 _cbsCode) {
        _sIdentifier = _cbsCode;
    }
}
