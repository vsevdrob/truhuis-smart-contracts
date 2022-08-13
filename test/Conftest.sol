// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "@core/addresser/TruhuisAddresser.sol";
import "@core/appraiser/TruhuisAppraiser.sol";
import "@core/bank/TruhuisBank.sol";
import "@core/cadastre/TruhuisCadastre.sol";
import "@core/inspector/TruhuisInspector.sol";
import "@core/notary/TruhuisNotary.sol";
import "@core/state/Municipality.sol";
import "@core/state/PersonalRecordsDatabase.sol";
import "@core/state/TaxAdministration.sol";
import "@core/trade/TruhuisTrade.sol";
import "@mocks/MockERC20EURT.sol";
import "@interfaces/IPersonalRecordsDatabase.sol";
import "@interfaces/IPurchaseAgreement.sol";

/**
 * @title Conftest
 * @author vsevdrob
 * @notice Configurations for tests.
 */
contract Conftest is Test {
    // Truhuis account.
    address public sTruhuis;
    // Sellers accounts.
    address public sAlice = address(0x1);
    address public sBob = address(0x2);
    address public sCharlie = address(0x3);
    // Buyers accounts.
    address public sDave = address(0x4);
    address public sEve = address(0x5);
    address public sFerdie = address(0x6);
    // Municipalities accounts.
    address public sAmsterdam = address(0x7);
    address public sRotterdam = address(0x8);
    address public sTheHague = address(0x9);
    // Ministry of the Interior and Kingdom Relations (IKR).
    address public sMinistryOfIKR = address(0x10);
    // Ministry of Finance (Fin).
    address public sMinistryOfFin = address(0x11);

    // Truhuis contracts as well as state and currency contracts.
    TruhuisAddresser public sAddresser;
    TruhuisAppraiser public sAppraiser;
    TruhuisBank public sBank;
    TruhuisCadastre public sCadastre;
    TruhuisInspector public sInspector;
    TruhuisNotary public sNotary;
    MockERC20EURT public sMockERC20EURT;
    Municipality public sMunicipalityA;
    Municipality public sMunicipalityR;
    Municipality public sMunicipalityH;
    PersonalRecordsDatabase public sPersonalRecordsDatabase;
    TaxAdministration public sTaxAdministration;
    TruhuisTrade public sTrade;

    /// @dev Identifier for the municipality of Amsterdam.
    bytes4 public constant S_AMSTERDAM = bytes4("0363");
    /// @dev Identifier for the municipality of Rotterdam.
    bytes4 public constant S_ROTTERDAM = bytes4("0599");
    /// @dev Identifier for the municipality of The Hague.
    bytes4 public constant S_THE_HAGUE = bytes4("0518");

    /// @dev Identifier for Truhuis Addresser smart contract.
    bytes32 public constant S_ADDRESSER = "ADDRESSER";
    /// @dev Identifier for Truhuis Appraiser smart contract.
    bytes32 public constant S_APPRAISER = "APPRAISER";
    /// @dev Identifier for Truhuis Bank smart contract.
    bytes32 public constant S_BANK = "BANK";
    /// @dev Identifier for Truhuis Cadastre smart contract.
    bytes32 public constant S_CADASTRE = "CADASTRE";
    /// @dev Identifier for Truhuis Inspector smart contract.
    bytes32 public constant S_INSPECTOR = "INSPECTOR";
    /// @dev Identifier for Truhuis Notary smart contract.
    bytes32 public constant S_NOTARY = "NOTARY";
    /// @dev Identifier for Personal Records Database smart contract.
    bytes32 public constant S_PERSONAL_RECORDS_DATABASE =
        "PERSONAL RECORDS DATABASE";
    /// @dev Identifier for Chainlink Price Feed smart contract.
    bytes32 public constant S_PRICE_ORACLE = "PRICE ORACLE";
    /// @dev Identifier for Tax Administration smart contract.
    bytes32 public constant S_TAX_ADMINISTRATION = "TAX ADMINISTRATION";
    /// @dev Identifier for Truhuis Trade smart contract.
    bytes32 public constant S_TRADE = "TRADE";

    /// @dev Contract URI related to the cadastre.
    string public sCadastreContractURI = "ipfs://";
    /// @dev Token URI of token ID 1.
    string public sTokenURI1 = "ipfs://1";
    /// @dev Token URI of token ID 2.
    string public sTokenURI2 = "ipfs://2";

    /// @dev Truhuis Marketplace initial service fee.
    uint96 public sServiceFee = 250; // 2.5 %

    /// @dev Transfer tax ID one.
    uint256 public sTaxIdOne = 1;
    /// @dev Transfer tax amount in % (e.g. 100 = 1%; 1000 = 10%)
    uint96 public sTransferTaxBasis = 200;

    PersonalRecords public sPersonalRecordsDave;
    PersonalRecords public sPersonalRecordsEve;
    PersonalRecords public sPersonalRecordsFerdie;

    constructor() {
        sTruhuis = msg.sender;
    }

    function _deploy() internal {
        vm.startPrank(sTruhuis);
        sAddresser = new TruhuisAddresser();
        sAppraiser = new TruhuisAppraiser(address(sAddresser));
        sBank = new TruhuisBank(address(sAddresser));
        sCadastre = new TruhuisCadastre(
            address(sAddresser),
            sCadastreContractURI
        );
        sInspector = new TruhuisInspector(address(sAddresser));
        sNotary = new TruhuisNotary(address(sAddresser));
        sMockERC20EURT = new MockERC20EURT(sTruhuis, 1 * 1000000 * 1000000);
        vm.stopPrank();

        vm.startPrank(sAmsterdam);
        sMunicipalityA = new Municipality(S_AMSTERDAM);
        vm.stopPrank();

        vm.startPrank(sRotterdam);
        sMunicipalityR = new Municipality(S_ROTTERDAM);
        vm.stopPrank();

        vm.startPrank(sTheHague);
        sMunicipalityH = new Municipality(S_THE_HAGUE);
        vm.stopPrank();

        vm.startPrank(sMinistryOfIKR);
        sPersonalRecordsDatabase = new PersonalRecordsDatabase(
            address(sAddresser)
        );
        vm.stopPrank();

        vm.startPrank(sMinistryOfFin);
        sTaxAdministration = new TaxAdministration(
            address(sAddresser)
        );
        vm.stopPrank();

        vm.startPrank(sTruhuis);
        sTrade = new TruhuisTrade(address(sAddresser), sServiceFee);
        vm.stopPrank();

        _refuelAccountsERC20();
    }

    function _updateAddresses() internal {
        vm.startPrank(sTruhuis);
        sAddresser.registerMunicipality(address(sMunicipalityA), S_AMSTERDAM);
        sAddresser.registerMunicipality(address(sMunicipalityR), S_ROTTERDAM);
        sAddresser.registerMunicipality(address(sMunicipalityH), S_THE_HAGUE);
        sAddresser.updateAddress(address(sAppraiser), S_APPRAISER);
        sAddresser.updateAddress(address(sBank), S_BANK);
        sAddresser.updateAddress(address(sCadastre), S_CADASTRE);
        sAddresser.updateAddress(address(sInspector), S_INSPECTOR);
        sAddresser.updateAddress(address(sNotary), S_NOTARY);
        sAddresser.updateAddress(
            address(sPersonalRecordsDatabase),
            S_PERSONAL_RECORDS_DATABASE
        );
        sAddresser.updateAddress(
            address(sTaxAdministration),
            S_TAX_ADMINISTRATION
        );
        sAddresser.updateAddress(address(sTrade), S_TRADE);
        vm.stopPrank();
    }

    function _updateTax() internal {
        vm.startPrank(sMinistryOfFin);
        sTaxAdministration.updateTax(sTaxIdOne, sTransferTaxBasis);
        vm.stopPrank();
    }

    function _storeBuyersPersonalRecords() internal {
        vm.startPrank(address(sMunicipalityA));
        uint256 txIdDave = sPersonalRecordsDatabase.getTxIds();
        sPersonalRecordsDatabase.submitRequest([sDave]);
        vm.stopPrank();

        vm.startPrank(address(sMunicipalityR));
        uint256 txIdEve = sPersonalRecordsDatabase.getTxIds();
        sPersonalRecordsDatabase.submitRequest([sEve]);
        vm.stopPrank();

        vm.startPrank(address(sMunicipalityH));
        uint256 txIdFerdie = sPersonalRecordsDatabase.getTxIds();
        sPersonalRecordsDatabase.submitRequest([sFerdie]);
        vm.stopPrank();

        vm.startPrank(sDave);
        sPersonalRecordsDatabase.confirmRequest(txIdDave);
        vm.stopPrank();

        vm.startPrank(sEve);
        sPersonalRecordsDatabase.confirmRequest(txIdEve);
        vm.stopPrank();

        vm.startPrank(sFerdie);
        sPersonalRecordsDatabase.confirmRequest(txIdFerdie);
        vm.stopPrank();

        sPersonalRecordsDave = PersonalRecords({
            name: Name({first: bytes32("Dave"), last: bytes32("Bakker")}),
            gender: Gender.MALE,
            account: address(sDave),
            dateOfBirth: DateOfBirth({
                day: uint24(9),
                month: uint24(12),
                year: uint24(1999)
            }),
            placeOfBirth: PlaceOfBirth({
                city: bytes32("Amsterdam"),
                province: bytes32("North Holland"),
                country: bytes3("NLD")
            }),
            parents: Parents({
                father: 0x56206543c9094648296803d9d0AF3CeBA1D211D9,
                mother: 0x2Ea31aBe305D675e7037886Ed4edd162172a26ED
            }),
            civilState: CivilStatus.MARRIED,
            children: Children({
                hasChildren: true,
                childrenAccounts: [
                    0x26A6a0C2eD5A5c4E8da6710F58c023cb498BEE39,
                    0x49B8326B947a6f97E9F66743E02bC9090e7BA515,
                    address(0)
                ]
            }),
            residency: Residency.DUTCH_NATIONALITY,
            currentAddress: CurrentAddress({
                street: bytes32("Kerkstraat"),
                houseNumber: uint8(1),
                postcode: bytes7("1000 AC"),
                municipality: S_AMSTERDAM
            })
        });

        sPersonalRecordsEve = PersonalRecords({
            name: Name({first: bytes32("Eve"), last: bytes32("de Vries")}),
            gender: Gender.FEMALE,
            account: address(sEve),
            dateOfBirth: DateOfBirth({
                day: uint24(2),
                month: uint24(9),
                year: uint24(1992)
            }),
            placeOfBirth: PlaceOfBirth({
                city: bytes32("Rotterdam"),
                province: bytes32("South Holland"),
                country: bytes3("NLD")
            }),
            parents: Parents({
                father: 0x8cbEbE6336D52dE9fe961FF994E0A176Ace3Adf4,
                mother: 0xfABdD57aeb73BED95c73015406e2Ce218BE9D7b5
            }),
            civilState: CivilStatus.UNMARRIED,
            children: Children({
                hasChildren: false,
                childrenAccounts: [address(0), address(0), address(0)]
            }),
            residency: Residency.DUTCH_NATIONALITY,
            currentAddress: CurrentAddress({
                street: bytes32("Stationsweg"),
                houseNumber: uint8(1),
                postcode: bytes7("2491 AC"),
                municipality: S_ROTTERDAM
            })
        });

        sPersonalRecordsFerdie = PersonalRecords({
            name: Name({first: bytes32("Ferdie"), last: bytes32("Timmermans")}),
            gender: Gender.MALE,
            account: address(sFerdie),
            dateOfBirth: DateOfBirth({
                day: uint24(26),
                month: uint24(7),
                year: uint24(2003)
            }),
            placeOfBirth: PlaceOfBirth({
                city: bytes32("The Hague"),
                province: bytes32("South Holland"),
                country: bytes3("NLD")
            }),
            parents: Parents({
                father: 0x794E68896Dd7E048134Cf8e33777B8684D0fFc39,
                mother: 0x82501d3cA8f24490977313431ceC6b17Fe63a73C
            }),
            civilState: CivilStatus.UNMARRIED,
            children: Children({
                hasChildren: false,
                childrenAccounts: [address(0), address(0), address(0)]
            }),
            residency: Residency.DUTCH_NATIONALITY,
            currentAddress: CurrentAddress({
                street: bytes32("Beatrixstraat"),
                houseNumber: uint8(1),
                postcode: bytes7("2491 AC"),
                municipality: S_THE_HAGUE
            })
        });

        vm.startPrank(address(sMunicipalityA));
        sPersonalRecordsDatabase.storePersonalRecords(
            sPersonalRecordsDave,
            S_AMSTERDAM,
            txIdDave
        );
        vm.stopPrank();

        vm.startPrank(address(sMunicipalityR));
        sPersonalRecordsDatabase.storePersonalRecords(
            sPersonalRecordsEve,
            S_ROTTERDAM,
            txIdEve
        );
        vm.stopPrank();

        vm.startPrank(address(sMunicipalityH));
        sPersonalRecordsDatabase.storePersonalRecords(
            sPersonalRecordsFerdie,
            S_THE_HAGUE,
            txIdFerdie
        );
        vm.stopPrank();
    }

    function _storeSellersPersonalRecords() internal {
        vm.startPrank(address(sMunicipalityA));
        uint256 txIdAlice = sPersonalRecordsDatabase.getTxIds();
        sPersonalRecordsDatabase.submitRequest([sAlice]);
        vm.stopPrank();

        vm.startPrank(address(sMunicipalityR));
        uint256 txIdBob = sPersonalRecordsDatabase.getTxIds();
        sPersonalRecordsDatabase.submitRequest([sBob]);
        vm.stopPrank();

        vm.startPrank(address(sMunicipalityH));
        uint256 txIdCharlie = sPersonalRecordsDatabase.getTxIds();
        sPersonalRecordsDatabase.submitRequest([sCharlie]);
        vm.stopPrank();

        vm.startPrank(sAlice);
        sPersonalRecordsDatabase.confirmRequest(txIdAlice);
        vm.stopPrank();

        vm.startPrank(sBob);
        sPersonalRecordsDatabase.confirmRequest(txIdBob);
        vm.stopPrank();

        vm.startPrank(sCharlie);
        sPersonalRecordsDatabase.confirmRequest(txIdCharlie);
        vm.stopPrank();

        PersonalRecords memory personalRecordsAlice = PersonalRecords({
            name: Name({first: bytes32("Alice"), last: bytes32("Jansen")}),
            gender: Gender.FEMALE,
            account: address(sAlice),
            dateOfBirth: DateOfBirth({
                day: uint24(4),
                month: uint24(5),
                year: uint24(2000)
            }),
            placeOfBirth: PlaceOfBirth({
                city: bytes32("Amsterdam"),
                province: bytes32("North Holland"),
                country: bytes3("NLD")
            }),
            parents: Parents({
                father: 0x2A0FAc8aC01A7C14F70E57FB5bc773090e999039,
                mother: 0x61dBE16043102fC80a67da263FD29A5CF76A9502
            }),
            civilState: CivilStatus.MARRIED,
            children: Children({
                hasChildren: true,
                childrenAccounts: [
                    0xb1962E00a5F9205b3CeFFbfc9Aa867958b4D6B9a,
                    0x0c33309c711C949f64946df0BC45276688395AA5,
                    address(0)
                ]
            }),
            residency: Residency.DUTCH_NATIONALITY,
            currentAddress: CurrentAddress({
                street: bytes32("Julianastraat"),
                houseNumber: uint8(1),
                postcode: bytes7("1000 AB"),
                municipality: S_AMSTERDAM
            })
        });

        PersonalRecords memory personalRecordsBob = PersonalRecords({
            name: Name({first: bytes32("Bob"), last: bytes32("van Dijk")}),
            gender: Gender.MALE,
            account: address(sBob),
            dateOfBirth: DateOfBirth({
                day: uint24(30),
                month: uint24(6),
                year: uint24(2002)
            }),
            placeOfBirth: PlaceOfBirth({
                city: bytes32("Rotterdam"),
                province: bytes32("South Holland"),
                country: bytes3("NLD")
            }),
            parents: Parents({
                father: 0xEAF1a76a2980aBd1ECe7aFbC62DFF14d37910eDe,
                mother: 0xBdd57A7471811b2799335e4CcDD57Ff3aB5163CF
            }),
            civilState: CivilStatus.UNMARRIED,
            children: Children({
                hasChildren: false,
                childrenAccounts: [address(0), address(0), address(0)]
            }),
            residency: Residency.DUTCH_NATIONALITY,
            currentAddress: CurrentAddress({
                street: bytes32("Willemstraat"),
                houseNumber: uint8(1),
                postcode: bytes7("2491 AB"),
                municipality: S_ROTTERDAM
            })
        });

        PersonalRecords memory personalRecordsCharlie = PersonalRecords({
            name: Name({
                first: bytes32("Charlie"),
                last: bytes32("Schoenmaker")
            }),
            gender: Gender.FEMALE,
            account: address(sCharlie),
            dateOfBirth: DateOfBirth({
                day: uint24(19),
                month: uint24(1),
                year: uint24(1998)
            }),
            placeOfBirth: PlaceOfBirth({
                city: bytes32("The Hague"),
                province: bytes32("South Holland"),
                country: bytes3("NLD")
            }),
            parents: Parents({
                father: 0x0D9B45438c85C1dC623feD4302f4a80bBf61A621,
                mother: 0x1f5236595319F3E08B92597A3386d86dcc12c8FA
            }),
            civilState: CivilStatus.UNMARRIED,
            children: Children({
                hasChildren: false,
                childrenAccounts: [address(0), address(0), address(0)]
            }),
            residency: Residency.DUTCH_NATIONALITY,
            currentAddress: CurrentAddress({
                street: bytes32("Oranjestraat"),
                houseNumber: uint8(1),
                postcode: bytes7("2491 AB"),
                municipality: S_THE_HAGUE
            })
        });

        vm.startPrank(address(sMunicipalityA));
        sPersonalRecordsDatabase.storePersonalRecords(
            personalRecordsAlice,
            S_AMSTERDAM,
            txIdAlice
        );
        vm.stopPrank();

        vm.startPrank(address(sMunicipalityR));
        sPersonalRecordsDatabase.storePersonalRecords(
            personalRecordsBob,
            S_ROTTERDAM,
            txIdBob
        );
        vm.stopPrank();

        vm.startPrank(address(sMunicipalityH));
        sPersonalRecordsDatabase.storePersonalRecords(
            personalRecordsCharlie,
            S_THE_HAGUE,
            txIdCharlie
        );
        vm.stopPrank();
    }

    function _refuelAccountsERC20() private {
        vm.startPrank(sTruhuis);
        // Send EURT to the accounts.
        sMockERC20EURT.transfer(sAlice, 10000000);
        sMockERC20EURT.transfer(sBob, 10000000);
        sMockERC20EURT.transfer(sCharlie, 10000000);
        sMockERC20EURT.transfer(sDave, 10000000);
        sMockERC20EURT.transfer(sEve, 10000000);
        sMockERC20EURT.transfer(sFerdie, 10000000);
        vm.stopPrank();
    }
}
