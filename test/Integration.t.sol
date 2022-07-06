// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Test.sol";
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
import "@interfaces/IPersonalRecordsDatabase.sol";
import "@interfaces/IPurchaseAgreement.sol";

/**
 * @title TruhuisTest
 * @author vsevdrob
 * @notice Integration test contract. Only on development network.
 */
contract TruhuisTest is Test {
    // Truhuis account.
    address public truhuis;
    // Sellers accounts.
    address public alice = address(0x1);
    address public bob = address(0x2);
    address public charlie = address(0x3);
    // Buyers accounts.
    address public dave = address(0x4);
    address public eve = address(0x5);
    address public ferdie = address(0x6);

    uint256 public immovablePropertyPrice = 690000;
    uint256 public movablePropertyPrice = 15000;
    uint256 public salesTaxCosts = (movablePropertyPrice / 100) * 21;
    uint256 public transferTaxCosts = (immovablePropertyPrice / 100) * 2;
    uint256 public amountToArrange = immovablePropertyPrice +
        movablePropertyPrice +
        salesTaxCosts +
        transferTaxCosts +
        (100 * 3);


    // Truhuis contracts as well as state contracts.
    TruhuisAddressRegistry public addressRegistry;
    TruhuisAppraiser public appraiser;
    TruhuisBank public bank;
    TruhuisCadastre public cadastre;
    TruhuisCurrencyRegistry public currencyRegistry;
    TruhuisInspector public inspector;
    TruhuisNotary public notary;
    MockERC20EURT public mockERC20EURT;
    Municipality public municipalityA;
    Municipality public municipalityR;
    Municipality public municipalityH;
    PersonalRecordsDatabase public personalRecordsDatabase;
    TaxAdministration public taxAdministration;
    TruhuisTrade public trade;

    // Municipalites with their unique CBS-code identifier.
    bytes4 public constant AMSTERDAM = bytes4("0363");
    bytes4 public constant ROTTERDAM = bytes4("0599");
    bytes4 public constant THE_HAGUE = bytes4("0518");

    constructor() {
        truhuis = msg.sender;
    }

    function testTruhuis() public {
        // Deploy all contracts.
        _deploy();

        // Update addresses in the address registry.
        _updateAddresses();

        // Add a new currency.
        _addNewCurrency();

        // Store personal data.
        _storePersonalDataSellers();
        _storePersonalDataBuyers();

        // Produce NFT immovable properties and transfer to sellers.
        _produceNFT();

        // List NFTs.
        _list();

        // Create offer.
        _createOffer();

        // Accept offer.
        _acceptOffer();

        // Draw up a purchase agreement.
        _drawUpPurchaseAgreement();

        // Fulfill buyer's guarantee.
        _fulfillGuarantee();

        // Carry out structural inspection.
        _carryOutStructuralInspection();

        // Fulfill payment.
        _fulfillPayment();

        // Draw deed of delivery.
        _drawUpDeedOfDelivery();

        //vm.startPrank(truhuis);
        //vm.stopPrank();
        
        _withdrawProceeds();

        assertEq(cadastre.ownerOf(1), dave);
        assertEq(truhuis, msg.sender);

        emit log_uint(mockERC20EURT.balanceOf(dave));
        emit log_uint(mockERC20EURT.balanceOf(alice));
    }

    function _withdrawProceeds() private {
        vm.startPrank(alice);
        bank.withdrawProceeds(address(mockERC20EURT));
        vm.stopPrank();
    }

    function _drawUpDeedOfDelivery() private {
        vm.startPrank(alice);
        uint256 txId = cadastre.getTxIds();
        cadastre.submitTransfer(1, 1);
        cadastre.confirmTransfer(1, txId);
        cadastre.approve(address(notary), 1);
        vm.stopPrank();

        vm.warp(4 days);

        notary.drawUpDeedOfDelivery(1, 1);
    }

    function _carryOutStructuralInspection() private {
        inspector.carryOutStructuralInspection(1);
    }

    function _fulfillPayment() private {
        vm.startPrank(dave);
        mockERC20EURT.approve(address(bank), amountToArrange);
        bank.fulfillPayment(1);
        vm.stopPrank();
    }

    function _fulfillGuarantee() private {
        vm.startPrank(dave);
        mockERC20EURT.approve(address(bank), ((690000 * 10**18) / 100) * 10);
        bank.fulfillGuarantee(1, TypeOfGuarantee.DEPOSIT);
        vm.stopPrank();
    }

    function _acceptOffer() private {
        vm.startPrank(alice);
        trade.acceptOffer(dave, 1, 1);
        vm.stopPrank();
    }

    function _createOffer() private {
        vm.startPrank(dave);
        trade.createOffer(
            address(mockERC20EURT),
            block.timestamp + 5 days,
            690000,
            1
        );
        vm.stopPrank();

        vm.startPrank(eve);
        trade.createOffer(
            address(mockERC20EURT),
            block.timestamp + 3 days,
            410000,
            2
        );
        vm.stopPrank();

        vm.startPrank(ferdie);
        trade.createOffer(
            address(mockERC20EURT),
            block.timestamp + 14 days,
            520000,
            3
        );
        vm.stopPrank();
    }

    function _list() private {
        vm.startPrank(alice);
        trade.list(address(mockERC20EURT), 756200, 1);
        vm.stopPrank();

        vm.startPrank(bob);
        trade.list(address(mockERC20EURT), 525000, 2);
        vm.stopPrank();

        vm.startPrank(charlie);
        trade.list(address(mockERC20EURT), 590000, 3);
        vm.stopPrank();
    }

    function _produceNFT() private {
        cadastre.produceNFT(alice, "ipfs://0");
        cadastre.produceNFT(bob, "ipfs://1");
        cadastre.produceNFT(charlie, "ipfs://2");
    }

    function _drawUpPurchaseAgreement() private {
        PurchaseAgreementStruct
            memory purchaseAgreementAliceDave = PurchaseAgreementStruct({
                exists: true,
                id: 0,
                sellAndPurchase: SellAndPurchase({
                    immovableProperty: ImmovableProperty({
                        isPurchaseCancelled: false,
                        price: immovablePropertyPrice,
                        tokenId: 1
                    }),
                    movableProperties: MovableProperties({
                        listOfItems: "ipfs://",
                        price: movablePropertyPrice
                    })
                }),
                costs: Costs({
                    cadastre: CadastreCosts({
                        isPaid: false,
                        amount: 100,
                        payer: Party.BUYER
                    }),
                    notary: NotaryCosts({
                        isPaid: false,
                        amount: 100 ,
                        payer: Party.BUYER
                    }),
                    taxAdministration: TaxAdministrationCosts({
                        isPaid: false,
                        salesTaxAmount: salesTaxCosts,
                        transferTaxAmount: transferTaxCosts,
                        payer: Party.BUYER
                    }),
                    trade: TradeCosts({
                        isPaid: false,
                        amount: 100,
                        payer: Party.BUYER
                    })
                }),
                payment: Payment({
                    currency: address(mockERC20EURT),
                    isFulfilled: false
                }),
                transferOfOwnership: TransferOfOwnership({
                    dateOfActualTransfer: block.timestamp + 10,
                    dateOfLegalTransfer: block.timestamp + 10
                }),
                bankGuaranteeOrDeposit: BankGuaranteeOrDeposit({
                    isFulfilled: false,
                    bankGuarantee: BankGuarantee({
                        amountToApprove: ((690000) / 100) * 10,
                        dateWhenApproved: 0,
                        deadlineToApprove: block.timestamp + 8 weeks
                    }),
                    deposit: Deposit({
                        amountToDeposit: ((690000) / 100) * 10,
                        dateWhenDeposited: 0,
                        deadlineToDeposit: block.timestamp + 8 weeks
                    }),
                    typeOfGuarantee: TypeOfGuarantee.DEPOSIT
                }),
                identity: Identity({
                    buyer: Buyer({account: dave, coBuyer: address(0)}),
                    seller: Seller({account: alice, coSeller: address(0)})
                }),
                resolutiveConditions: ResolutiveConditions({
                    financingArranging: FinancingArranging({
                        isDissolved: false,
                        amountToArrange: amountToArrange,
                        deadlineToArrange: block.timestamp + 10,
                        mortgageType: MortgageType.NONE
                    }),
                    structuralInspection: StructuralInspection({
                        inspector: address(inspector),
                        isDissolved: false,
                        amountToPayForRepairOfDefects: 0,
                        deadlineToInspect: block.timestamp + 1 weeks
                    })
                }),
                coolingOffPeriod: CoolingOffPeriod({
                    endTime: uint32(block.timestamp + 3 days),
                    startTime: uint32(block.timestamp)
                }),
                writtenRecord: WrittenRecord({
                    hasBuyerSigned: true,
                    hasSellerSigned: true
                }),
                dutchLaw: DutchLaw({
                    isApplied: true
                })
            });

        notary.drawUpPurchaseAgreement(purchaseAgreementAliceDave);
    }

    function _deploy() private {
        addressRegistry = new TruhuisAddressRegistry();
        appraiser = new TruhuisAppraiser(address(addressRegistry));
        bank = new TruhuisBank(address(addressRegistry));
        cadastre = new TruhuisCadastre(
            address(addressRegistry),
            "Truhuis Cadastre"
        );
        currencyRegistry = new TruhuisCurrencyRegistry();
        inspector = new TruhuisInspector(address(addressRegistry));
        notary = new TruhuisNotary(address(addressRegistry));
        mockERC20EURT = new MockERC20EURT(truhuis, 1 * 1000000 * 1000000);
        municipalityA = new Municipality(AMSTERDAM);
        municipalityR = new Municipality(ROTTERDAM);
        municipalityH = new Municipality(THE_HAGUE);
        personalRecordsDatabase = new PersonalRecordsDatabase(
            address(addressRegistry)
        );
        taxAdministration = new TaxAdministration();
        trade = new TruhuisTrade(address(addressRegistry), 50);

        // Send EURT to the accounts.
        vm.startPrank(truhuis);
        mockERC20EURT.transfer(alice, 10000000);
        mockERC20EURT.transfer(bob, 10000000);
        mockERC20EURT.transfer(charlie, 10000000);
        mockERC20EURT.transfer(dave, 10000000);
        mockERC20EURT.transfer(eve, 10000000);
        mockERC20EURT.transfer(ferdie, 10000000);
        vm.stopPrank();
    }

    function _updateAddresses() private {
        addressRegistry.updateAddress(address(appraiser), bytes32("APPRAISER"));
        addressRegistry.updateAddress(address(bank), bytes32("BANK"));
        addressRegistry.updateAddress(address(cadastre), bytes32("CADASTRE"));
        addressRegistry.updateAddress(
            address(currencyRegistry),
            bytes32("CURRENCY_REGISTRY")
        );
        addressRegistry.updateAddress(address(inspector), bytes32("INSPECTOR"));
        addressRegistry.updateAddress(address(notary), bytes32("NOTARY"));
        addressRegistry.registerMunicipality(address(municipalityA), AMSTERDAM);
        addressRegistry.registerMunicipality(address(municipalityR), ROTTERDAM);
        addressRegistry.registerMunicipality(address(municipalityH), THE_HAGUE);
        addressRegistry.updateAddress(
            address(personalRecordsDatabase),
            bytes32("PERSONAL_RECORDS_DATABASE")
        );
        addressRegistry.updateAddress(
            address(taxAdministration),
            bytes32("TAX_ADMINISTRATION")
        );
        addressRegistry.updateAddress(address(trade), bytes32("TRADE"));
    }

    function _addNewCurrency() private {
        currencyRegistry.add(address(mockERC20EURT));
    }

    function _storePersonalDataBuyers() private {
        vm.startPrank(address(municipalityA));
        uint256 txIdDave = personalRecordsDatabase.getTxIds();
        personalRecordsDatabase.submitRequest([dave]);
        vm.stopPrank();

        vm.startPrank(address(municipalityR));
        uint256 txIdEve = personalRecordsDatabase.getTxIds();
        personalRecordsDatabase.submitRequest([eve]);
        vm.stopPrank();

        vm.startPrank(address(municipalityH));
        uint256 txIdFerdie = personalRecordsDatabase.getTxIds();
        personalRecordsDatabase.submitRequest([ferdie]);
        vm.stopPrank();

        vm.startPrank(dave);
        personalRecordsDatabase.confirmRequest(txIdDave);
        vm.stopPrank();

        vm.startPrank(eve);
        personalRecordsDatabase.confirmRequest(txIdEve);
        vm.stopPrank();

        vm.startPrank(ferdie);
        personalRecordsDatabase.confirmRequest(txIdFerdie);
        vm.stopPrank();

        PersonalRecords memory personalRecordsDave = PersonalRecords({
            name: Name({first: bytes32("Dave"), last: bytes32("Bakker")}),
            gender: Gender.MALE,
            account: address(dave),
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
                municipality: AMSTERDAM
            })
        });

        PersonalRecords memory personalRecordsEve = PersonalRecords({
            name: Name({first: bytes32("Eve"), last: bytes32("de Vries")}),
            gender: Gender.FEMALE,
            account: address(eve),
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
                municipality: ROTTERDAM
            })
        });

        PersonalRecords memory personalRecordsFerdie = PersonalRecords({
            name: Name({first: bytes32("Ferdie"), last: bytes32("Timmermans")}),
            gender: Gender.MALE,
            account: address(ferdie),
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
                municipality: THE_HAGUE
            })
        });

        vm.startPrank(address(municipalityA));
        personalRecordsDatabase.storePersonalRecords(
            personalRecordsDave,
            AMSTERDAM,
            txIdDave
        );
        vm.stopPrank();

        vm.startPrank(address(municipalityR));
        personalRecordsDatabase.storePersonalRecords(
            personalRecordsEve,
            ROTTERDAM,
            txIdEve
        );
        vm.stopPrank();

        vm.startPrank(address(municipalityH));
        personalRecordsDatabase.storePersonalRecords(
            personalRecordsFerdie,
            THE_HAGUE,
            txIdFerdie
        );
        vm.stopPrank();
    }

    function _storePersonalDataSellers() private {
        vm.startPrank(address(municipalityA));
        uint256 txIdAlice = personalRecordsDatabase.getTxIds();
        personalRecordsDatabase.submitRequest([alice]);
        vm.stopPrank();

        vm.startPrank(address(municipalityR));
        uint256 txIdBob = personalRecordsDatabase.getTxIds();
        personalRecordsDatabase.submitRequest([bob]);
        vm.stopPrank();

        vm.startPrank(address(municipalityH));
        uint256 txIdCharlie = personalRecordsDatabase.getTxIds();
        personalRecordsDatabase.submitRequest([charlie]);
        vm.stopPrank();

        vm.startPrank(alice);
        personalRecordsDatabase.confirmRequest(txIdAlice);
        vm.stopPrank();

        vm.startPrank(bob);
        personalRecordsDatabase.confirmRequest(txIdBob);
        vm.stopPrank();

        vm.startPrank(charlie);
        personalRecordsDatabase.confirmRequest(txIdCharlie);
        vm.stopPrank();

        PersonalRecords memory personalRecordsAlice = PersonalRecords({
            name: Name({first: bytes32("Alice"), last: bytes32("Jansen")}),
            gender: Gender.FEMALE,
            account: address(alice),
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
                municipality: AMSTERDAM
            })
        });

        PersonalRecords memory personalRecordsBob = PersonalRecords({
            name: Name({first: bytes32("Bob"), last: bytes32("van Dijk")}),
            gender: Gender.MALE,
            account: address(bob),
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
                municipality: ROTTERDAM
            })
        });

        PersonalRecords memory personalRecordsCharlie = PersonalRecords({
            name: Name({
                first: bytes32("Charlie"),
                last: bytes32("Schoenmaker")
            }),
            gender: Gender.FEMALE,
            account: address(charlie),
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
                municipality: THE_HAGUE
            })
        });

        vm.startPrank(address(municipalityA));
        personalRecordsDatabase.storePersonalRecords(
            personalRecordsAlice,
            AMSTERDAM,
            txIdAlice
        );
        vm.stopPrank();

        vm.startPrank(address(municipalityR));
        personalRecordsDatabase.storePersonalRecords(
            personalRecordsBob,
            ROTTERDAM,
            txIdBob
        );
        vm.stopPrank();

        vm.startPrank(address(municipalityH));
        personalRecordsDatabase.storePersonalRecords(
            personalRecordsCharlie,
            THE_HAGUE,
            txIdCharlie
        );
        vm.stopPrank();
    }
}
