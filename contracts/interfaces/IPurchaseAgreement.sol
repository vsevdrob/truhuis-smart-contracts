// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

error CoolingOffPeriod__InvalidEndTime();
error CoolingOffPeriod__InvalidStartTime();
error DutchLaw__IsNotApplied();

/**
 * @dev Article 1 Sell and purchase
 */

error SellAndPurchase__SellerIsNotOwner();
error SellAndPurchase__ListOfItemsIsEmpty();
error SellAndPurchase__ItemsPriceMustBeGreaterThanZero();
error SellAndPurchase__TokenNotExists(uint256 tokenId);
error SellAndPurchase__PurchasePriceMustBeGreaterThanZero();

struct MovableProperties {
    string listOfItems; // URI
    uint256 price;
}

struct ImmovableProperty {
    uint256 purchasePrice;
    uint256 tokenId;
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

struct Cadastre {
    uint256 costs;
    Party payer;
}

struct Marketplace {
    uint256 costs;
    Party payer;
}

struct Notary {
    uint256 costs;
    Party payer;
}

struct SalesTax {
    uint256 costs;
    Party payer;
}

struct TransferTax {
    uint256 costs;
    Party payer;
}

struct Costs {
    Cadastre cadastre;
    Marketplace marketplace;
    Notary notary;
    SalesTax salesTax;
    TransferTax transferTax;
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
    BANK_GUARANTEE,
    DEPOSIT
}

struct Deposit {
    bool isDeposited;
    uint256 amountToDeposit;
    uint256 dateWhenDeposited;
    uint256 deadlineToDeposit;
}

struct BankGuarantee {
    bool isApproved;
    uint256 amountToApprove;
    uint256 dateWhenApproved;
    uint256 deadlineToApprove;
}

struct BankGuaranteeOrDeposit {
    TypeOfGuarantee typeOfGuarantee;
    BankGuarantee bankGuarantee;
    Deposit deposit;
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
 * @dev Article 17 Written record.
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
    SellAndPurchase sellAndPurchase; // 1
    Costs costs; // 2
    TransferOfOwnership transferOfOwnership; // 4
    BankGuaranteeOrDeposit bankGuaranteeOrDeposit; // 5
    Identity identity; // 14
    ResolutiveConditions resolutiveConditions; // 15
    CoolingOffPeriod coolingOffPeriod; // 16 
    WrittenRecord writtenRecord; // 17
    DutchLaw dutchLaw; // 18
}

interface IPurchaseAgreement {
}
