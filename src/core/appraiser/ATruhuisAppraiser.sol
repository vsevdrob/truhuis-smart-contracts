// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../address/TruhuisAddressRegistryAdapter.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract ATruhuisAppraiser is Ownable, TruhuisAddressRegistryAdapter {
    constructor(address _addressRegistry) {
        updateAddressRegistry(_addressRegistry);
    }
}
