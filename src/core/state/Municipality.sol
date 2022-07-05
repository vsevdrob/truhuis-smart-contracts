// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./AMunicipality.sol";

/*
 * TODO:    Store all the values in encrypted form.
 * TODO:    Make view functions payable for non official accounts and restrict
 *          who is allowed to ask for the identity information.
 */
contract Municipality is AMunicipality {
    constructor(bytes4 _cbsCode) AMunicipality(_cbsCode) {}
}
