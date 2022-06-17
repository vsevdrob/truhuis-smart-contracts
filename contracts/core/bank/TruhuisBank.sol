// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "../address/TruhuisAddressRegistryAdapter.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TruhuisBank is Ownable, TruhuisAddressRegistryAdapter {}
