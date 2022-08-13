// SPDX-License-Identifier: MIT

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
        _storeBuyersPersonalRecords();
        _storeSellersPersonalRecords();
    }

    function testTruhuis() public {

        // Add a new currency.
        _addNewCurrency();

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
}
