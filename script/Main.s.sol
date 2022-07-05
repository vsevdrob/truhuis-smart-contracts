// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./deploy/Deploy.s.sol";
import "forge-std/Script.sol";
import "@core/address/TruhuisAddressRegistry.sol";
import "@core/appraiser/TruhuisAppraiser.sol";
import "@core/bank/TruhuisBank.sol";
import "@core/cadastre/TruhuisCadastre.sol";
import "@core/currency/TruhuisCurrencyRegistry.sol";
import "@core/inspector/TruhuisInspector.sol";
import "@core/notary/TruhuisNotary.sol";
import "@core/state/Municipality.sol";
import "@core/state/PersonalRecordsDatabase.sol";
import "@core/state/TaxAdministration.sol";
import "@core/trade/TruhuisTrade.sol";

contract Main is Script, Deploy {
}
