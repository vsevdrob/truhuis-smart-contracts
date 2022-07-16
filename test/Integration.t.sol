// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@test/Conftest.sol";

/**
 * @title TruhuisTest
 * @author vsevdrob
 * @notice Integration test contract. Only on development network.
 */
contract TruhuisTest is Conftest {
    uint256 public immovablePropertyPrice = 690000;
    uint256 public movablePropertyPrice = 15000;
    uint256 public salesTaxCosts = (movablePropertyPrice / 100) * 21;
    uint256 public transferTaxCosts = (immovablePropertyPrice / 100) * 2;
    uint256 public amountToArrange =
        immovablePropertyPrice +
            movablePropertyPrice +
            salesTaxCosts +
            transferTaxCosts +
            (100 * 3);

    function setUp() public {
        _deploy();
        _updateAddresses();
        _updateTax();
    }

    function testTruhuis() public {

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

        _withdrawProceeds();

        assertEq(sCadastre.ownerOf(1), sDave);
        assertEq(sTruhuis, msg.sender);
    }

    function _withdrawProceeds() private {
        vm.startPrank(sAlice);
        sBank.withdrawProceeds(address(sMockERC20EURT));
        vm.stopPrank();
    }

    function _drawUpDeedOfDelivery() private {
        vm.startPrank(sAlice);
        uint256 txId = sCadastre.getTxIds();
        sCadastre.submitTransfer(1, 1);
        sCadastre.confirmTransfer(1, txId);
        sCadastre.approve(address(sNotary), 1);
        vm.stopPrank();

        vm.warp(4 days);

        vm.startPrank(sTruhuis);
        sNotary.drawUpDeedOfDelivery(1, 1);
        vm.stopPrank();
    }

    function _carryOutStructuralInspection() private {
        vm.startPrank(sTruhuis);
        sInspector.carryOutStructuralInspection(1);
        vm.stopPrank();
    }

    function _fulfillPayment() private {
        vm.startPrank(sDave);
        sMockERC20EURT.approve(address(sBank), amountToArrange);
        sBank.fulfillPayment(1);
        vm.stopPrank();
    }

    function _fulfillGuarantee() private {
        vm.startPrank(sDave);
        sMockERC20EURT.approve(address(sBank), ((690000 * 10**18) / 100) * 10);
        sBank.fulfillGuarantee(1, TypeOfGuarantee.DEPOSIT);
        vm.stopPrank();
    }

    function _acceptOffer() private {
        vm.startPrank(sAlice);
        sTrade.acceptOffer(sDave, 1, 1);
        vm.stopPrank();
    }

    function _createOffer() private {
        vm.startPrank(sDave);
        sTrade.createOffer(
            address(sMockERC20EURT),
            block.timestamp + 5 days,
            690000,
            1
        );
        vm.stopPrank();

        vm.startPrank(sEve);
        sTrade.createOffer(
            address(sMockERC20EURT),
            block.timestamp + 3 days,
            410000,
            2
        );
        vm.stopPrank();

        vm.startPrank(sFerdie);
        sTrade.createOffer(
            address(sMockERC20EURT),
            block.timestamp + 14 days,
            520000,
            3
        );
        vm.stopPrank();
    }

    function _list() private {
        vm.startPrank(sAlice);
        sTrade.list(address(sMockERC20EURT), 756200, 1);
        vm.stopPrank();

        vm.startPrank(sBob);
        sTrade.list(address(sMockERC20EURT), 525000, 2);
        vm.stopPrank();

        vm.startPrank(sCharlie);
        sTrade.list(address(sMockERC20EURT), 590000, 3);
        vm.stopPrank();
    }

    function _produceNFT() private {
        vm.startPrank(sTruhuis);
        sCadastre.produceNFT(sAlice, "ipfs://0");
        sCadastre.produceNFT(sBob, "ipfs://1");
        sCadastre.produceNFT(sCharlie, "ipfs://2");
        vm.stopPrank();
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
                        amount: 100,
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
                    currency: address(sMockERC20EURT),
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
                    buyer: Buyer({account: sDave, coBuyer: address(0)}),
                    seller: Seller({account: sAlice, coSeller: address(0)})
                }),
                resolutiveConditions: ResolutiveConditions({
                    financingArranging: FinancingArranging({
                        isDissolved: false,
                        amountToArrange: amountToArrange,
                        deadlineToArrange: block.timestamp + 10,
                        mortgageType: MortgageType.NONE
                    }),
                    structuralInspection: StructuralInspection({
                        inspector: address(sInspector),
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
                dutchLaw: DutchLaw({isApplied: true})
            });

        vm.startPrank(sTruhuis);
        sNotary.drawUpPurchaseAgreement(purchaseAgreementAliceDave);
        vm.stopPrank();
    }

    function _addNewCurrency() private {
        vm.startPrank(sTruhuis);
        sBank.registerCurrency(address(sMockERC20EURT));
        vm.stopPrank();
    }

    function _storePersonalDataBuyers() private {
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

        PersonalRecords memory personalRecordsDave = PersonalRecords({
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

        PersonalRecords memory personalRecordsEve = PersonalRecords({
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

        PersonalRecords memory personalRecordsFerdie = PersonalRecords({
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
            personalRecordsDave,
            S_AMSTERDAM,
            txIdDave
        );
        vm.stopPrank();

        vm.startPrank(address(sMunicipalityR));
        sPersonalRecordsDatabase.storePersonalRecords(
            personalRecordsEve,
            S_ROTTERDAM,
            txIdEve
        );
        vm.stopPrank();

        vm.startPrank(address(sMunicipalityH));
        sPersonalRecordsDatabase.storePersonalRecords(
            personalRecordsFerdie,
            S_THE_HAGUE,
            txIdFerdie
        );
        vm.stopPrank();
    }

    function _storePersonalDataSellers() private {
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
}
