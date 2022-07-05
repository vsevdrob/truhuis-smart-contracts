// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

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
import "@mocks/MockERC20EURT.sol";

contract Deploy is Script {
//    address truhuis; // = address(0x0);
//    address alice = address(0x1);
//    address bob = address(0x2);
//    address charlie = address(0x3);
//    address dave = address(0x4);
//    address eve = address(0x5);
//    address ferdie = address(0x6);
//
//    TruhuisAddressRegistry addressRegistry;
//    TruhuisAppraiser appraiser;
//    TruhuisBank bank;
//    TruhuisCadastre cadastre;
//    TruhuisCurrencyRegistry currencyRegistry;
//    TruhuisInspector inspector;
//    TruhuisNotary notary;
//    MockERC20EURT mockERC20EURT;
//    Municipality municipality;
//    PersonalRecordsDatabase personalRecordsDatabase;
//    TaxAdministration taxAdministration;
//    TruhuisTrade trade;
//
//    constructor() {
//        truhuis = msg.sender;
//    }
//
//    function deploy()
//        public
//    /*returns (
//        address,
//        address,
//        address,
//        address,
//        address,
//        address,
//        address,
//        address,
//        address,
//        address,
//        address
//    )*/
//    {
//        vm.startBroadcast();
//
//        addressRegistry = new TruhuisAddressRegistry();
//        appraiser = new TruhuisAppraiser();
//        bank = new TruhuisBank();
//        cadastre = new TruhuisCadastre(
//            address(addressRegistry),
//            "Truhuis Cadastre"
//        );
//        currencyRegistry = new TruhuisCurrencyRegistry();
//        inspector = new TruhuisInspector();
//        notary = new TruhuisNotary();
//        mockERC20EURT = new MockERC20EURT(truhuis, 10**12);
//        municipality = new Municipality();
//        personalRecordsDatabase = new PersonalRecordsDatabase();
//        taxAdministration = new TaxAdministration();
//        trade = new TruhuisTrade(address(addressRegistry), 50);
//
//        addressRegistry.updateAddress(address(appraiser), bytes32("APPRAISER"));
//        addressRegistry.updateAddress(address(bank), bytes32("BANK"));
//        addressRegistry.updateAddress(address(cadastre), bytes32("CADASTRE"));
//        addressRegistry.updateAddress(address(currencyRegistry), bytes32("CURRENCY_REGISTRY"));
//        addressRegistry.updateAddress(address(inspector), bytes32("INSPECTOR"));
//        addressRegistry.updateAddress(address(notary), bytes32("NOTARY"));
//        addressRegistry.registerMunicipality(address(municipality), 1);
//        addressRegistry.updateAddress(address(personalRecordsDatabase), bytes32(
//            "PERSONAL_RECORDS_DATABASE"
//        ));
//        addressRegistry.updateAddress(address(taxAdministration), bytes32("TAX_ADMINISTRATION"));
//        addressRegistry.updateAddress(address(trade), bytes32("TRADE"));
//
//        currencyRegistry.add(address(mockERC20EURT));
//
//        uint256 txId0 = personalRecordsDatabase.submitTransaction();
//        uint256 txId1 = personalRecordsDatabase.submitTransaction();
//        uint256 txId2 = personalRecordsDatabase.submitTransaction();
//        personalRecordsDatabase.confirmTransaction(txId0);
//        personalRecordsDatabase.confirmTransaction(txId1);
//        personalRecordsDatabase.confirmTransaction(txId2);
//
//        //vm.startPrank(alice);
//        //personalRecordsDatabase.confirmTransaction(txId0);
//        //vm.startPrank(bob);
//        //personalRecordsDatabase.confirmTransaction(txId1);
//        //vm.startPrank(charlie);
//        //personalRecordsDatabase.confirmTransaction(txId2);
//
//        //vm.startPrank(truhuis);
//
//        /*
//        TruhuisAddressRegistry addressRegistry = new TruhuisAddressRegistry();
//        TruhuisAppraiser appraiser = new TruhuisAppraiser();
//        TruhuisBank bank = new TruhuisBank();
//        TruhuisCadastre cadastre = new TruhuisCadastre(
//            address(addressRegistry),
//            "Truhuis Cadastre"
//        );
//        TruhuisCurrencyRegistry currencyRegistry = new TruhuisCurrencyRegistry();
//        TruhuisInspector inspector = new TruhuisInspector();
//        TruhuisNotary notary = new TruhuisNotary();
//        Municipality municipality = new Municipality();
//        PersonalRecordsDatabase personalRecordsDatabase = new PersonalRecordsDatabase();
//        TaxAdministration taxAdministration = new TaxAdministration();
//        TruhuisTrade trade = new TruhuisTrade(address(addressRegistry), 50);
//
//        TruhuisAddressRegistry addressRegistry = new TruhuisAddressRegistry();
//        TruhuisAppraiser appraiser = new TruhuisAppraiser();
//        TruhuisBank bank = new TruhuisBank();
//        TruhuisCadastre cadastre = new TruhuisCadastre(
//            address(addressRegistry),
//            "Truhuis Cadastre"
//        );
//        TruhuisCurrencyRegistry currencyRegistry = new TruhuisCurrencyRegistry();
//        TruhuisInspector inspector = new TruhuisInspector();
//        TruhuisNotary notary = new TruhuisNotary();
//        Municipality municipality = new Municipality();
//        PersonalRecordsDatabase personalRecordsDatabase = new PersonalRecordsDatabase();
//        TaxAdministration taxAdministration = new TaxAdministration();
//        TruhuisTrade trade = new TruhuisTrade(address(addressRegistry), 50);
//        */
//
//        vm.stopBroadcast();
//        /*
//        return (
//            address(addressRegistry),
//            address(appraiser),
//            address(bank),
//            address(cadastre),
//            address(currencyRegistry),
//            address(inspector),
//            address(notary),
//            address(municipality),
//            address(personalRecordsDatabase),
//            address(taxAdministration),
//            address(trade)
//        );
//        */
//    }
}
