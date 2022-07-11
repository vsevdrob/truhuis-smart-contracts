// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@core/addresser/TruhuisAddresserAPI.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract ATruhuisAppraiser is Ownable, TruhuisAddresserAPI {
    constructor(address _addresser) {
        updateAddresser(_addresser);
    }
}
