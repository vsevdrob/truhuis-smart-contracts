// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../address/TruhuisAddressRegistryAdapter.sol";

abstract contract ATruhuisAppraiser is TruhuisAddressRegistryAdapter {
    constructor(address _addressRegistry) {
        updateAddressRegistry(_addressRegistry);
    }
}
