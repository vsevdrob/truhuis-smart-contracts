// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {
    Listing,
    Stage,
    INVALID_STAGE,
    LISTING_NOT_EXISTS
} from "./ITruhuisMarketplace.sol";

error CoolingOffPeriod__InvalidEndTime();
error CoolingOffPeriod__InvalidStartTime();
error DutchLaw__IsNotApplied();
error Notary__CallerMustBeBank();
error Notary__CallerMustBeInspector();

error BUYERS_NOT_IDENTICAL(address buyer, address listingBuyer);
error CURRENCIES_NOT_IDENTICAL(address currency, address listingCurrency);
error SELLERS_NOT_IDENTICAL(address seller, address listingSeller);
error TOKEN_IDS_NOT_IDENTICAL(
    uint256 purchaseAgreementTokenId,
    uint256 listingTokenId
);

/**
 * @dev Article 1 Sell and purchase
 */

error SellAndPurchase__SellerIsNotOwner();
error SellAndPurchase__ListOfItemsIsEmpty();
error SellAndPurchase__ItemsPriceMustBeGreaterThanZero();
error SellAndPurchase__TokenNotExists(uint256 tokenId);
error SellAndPurchase__PurchasePriceMustBeGreaterThanZero();

struct ImmovableProperty {
    bool isPurchaseCancelled;
    uint256 price;
    uint256 tokenId;
}

struct MovableProperties {
    string listOfItems; // URI
    uint256 price;
}

struct SellAndPurchase {
    ImmovableProperty immovableProperty;
    MovableProperties movableProperties;
}

/**
 * @dev Article 2 Costs / Tranfer tax
 */

error Costs__CostsMustBeGreaterThanZero();
error Costs__PayerMustBeNotNone();

struct CadastreCosts {
    bool isPaid;
    uint256 amount;
    Party payer;
}

struct NotaryCosts {
    bool isPaid;
    uint256 amount;
    Party payer;
}

struct TaxAdministrationCosts {
    bool isPaid;
    uint256 salesTaxAmount;
    uint256 transferTaxAmount;
    Party payer;
}

struct TradeCosts {
    bool isPaid;
    uint256 amount;
    Party payer;
}

struct Costs {
    CadastreCosts cadastre;
    NotaryCosts notary;
    TaxAdministrationCosts taxAdministration;
    TradeCosts trade;
}

/**
 * @dev Article 3 Payment
 */

error Payment__AlreadyFulfilled();

struct Payment {
    address currency;
    bool isFulfilled;
}

/**
 * @dev Article 4 Transfer of ownership
 */

error TransferOfOwnership__InvalidDateOfActualTransfer();
error TransferOfOwnership__InvalidDateOfLegalTransfer();

struct TransferOfOwnership {
    uint256 dateOfActualTransfer;
    uint256 dateOfLegalTransfer;
}

/**
 * @dev Article 5 Bank guarantee / Deposit
 */

error BankGuaranteeOrDeposit__InvalidAmountToApprove();
error BankGuaranteeOrDeposit__InvalidAmountToDeposit();
error BankGuaranteeOrDeposit__InvalidDeadlineToApprove();
error BankGuaranteeOrDeposit__InvalidDeadlineToDeposit();

enum TypeOfGuarantee {
    NONE,
    BANK_GUARANTEE,
    DEPOSIT
}

struct Deposit {
    uint256 amountToDeposit;
    uint256 dateWhenDeposited;
    uint256 deadlineToDeposit;
}

struct BankGuarantee {
    uint256 amountToApprove;
    uint256 dateWhenApproved;
    uint256 deadlineToApprove;
}

struct BankGuaranteeOrDeposit {
    bool isPerformed;
    BankGuarantee bankGuarantee;
    Deposit deposit;
    TypeOfGuarantee typeOfGuarantee;
}

/**
 * @dev Article 14 Identity
 */

enum Party {
    NONE,
    BUYER,
    SELLER
}

struct Buyer {
    address account;
    address coBuyer;
}

struct Seller {
    address account;
    address coSeller;
}

struct Identity {
    Buyer buyer;
    Seller seller;
}

/**
 * @dev Article 15 Resolutive conditions
 */

error ResolutiveConditions__InvalidInspector();
error ResolutiveConditions__InvalidDeadlines();

enum MortgageType {
    NONE,
    LINEAR
    // ...
}

struct StructuralInspection {
    address inspector;
    bool isDissolved;
    uint256 amountToPayForRepairOfDefects;
    uint256 deadlineToInspect;
}

struct FinancingArranging {
    bool isDissolved;
    uint256 amountToArrange;
    uint256 deadlineToArrange;
    MortgageType mortgageType;
}

struct ResolutiveConditions {
    FinancingArranging financingArranging;
    StructuralInspection structuralInspection;
}

/**
 * @notice Article 16 Cooling-off period
 */
struct CoolingOffPeriod {
    uint32 endTime;
    uint32 startTime;
}

/**
 * @dev Article 17 Written record
 */

error WrittenRecord__BuyerMustSign();
error WrittenRecord__SellerMustSign();

struct WrittenRecord {
    bool hasBuyerSigned;
    bool hasSellerSigned;
}

/**
 * @dev Article 18 Dutch law
 */

struct DutchLaw {
    bool isApplied;
}

/**
 * @dev Purchase agreement
 */
struct PurchaseAgreementStruct {
    bool exists;
    uint256 id;
    SellAndPurchase sellAndPurchase; // 1
    Costs costs; // 2
    Payment payment; // 3
    TransferOfOwnership transferOfOwnership; // 4
    BankGuaranteeOrDeposit bankGuaranteeOrDeposit; // 5
    Identity identity; // 14
    ResolutiveConditions resolutiveConditions; // 15
    CoolingOffPeriod coolingOffPeriod; // 16
    WrittenRecord writtenRecord; // 17
    DutchLaw dutchLaw; // 18
}

interface IPurchaseAgreement {
    /**
     * @dev _
     */
    function setFinancingArrangingIsDissolved(uint256 _purchaseAgreementId)
        external;

    /**
     * @dev _
     */
    function setGuaranteeIsProvided(
        uint256 _purchaseAgreementId,
        TypeOfGuarantee _typeOfGuarantee
    ) external;

    /**
     * @dev _
     */
    function setPaymentIsFulfilled(uint256 _purchaseAgreementId) external;

    /**
     * @dev _
     */
    function setStructuralInspectionIsDissolved(uint256 _purchaseAgreementId)
        external;

    /**
     * @dev _
     */

    function getPurchaseAgreement(uint256 _purchaseAgreementId)
        external
        view
        returns (PurchaseAgreementStruct memory);
}
