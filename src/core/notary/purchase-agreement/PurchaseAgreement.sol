// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@interfaces/IPurchaseAgreement.sol";
import "@core/addresser/TruhuisAddresserAPI.sol";
import "./Article01SellAndPurchase.sol";
import "./Article02Costs.sol";
import "./Article03Payment.sol";
import "./Article04TransferOfOwnership.sol";
import "./Article05BankGuaranteeOrDeposit.sol";
import "./Article14Identity.sol";
import "./Article15ResolutiveConditions.sol";
import "./Article16CoolingOffPeriod.sol";
import "./Article17WrittenRecord.sol";
import "./Article18DutchLaw.sol";

/**
 * @title PurchaseAgreement
 * @author _
 * @notice If you buy or sell an NFT real estate, the agreements are recorded in
 *         a purchase agreement.
 */
contract PurchaseAgreement is
    TruhuisAddresserAPI,
    IPurchaseAgreement,
    Article01SellAndPurchase,
    Article02Costs,
    Article03Payment,
    Article04TransferOfOwnership,
    Article05BankGuaranteeOrDeposit,
    Article14Identity,
    Article15ResolutiveConditions,
    Article16CoolingOffPeriod,
    Article17WrittenRecord,
    Article18DutchLaw
{
    /* PRIVATE STORAGE */

    /// @dev Purchase agreement ID => Purchase agreement struct.
    mapping(uint256 => PurchaseAgreementStruct) private _sPurchaseAgreements;

    /// @dev Purchase agreement IDs.
    uint256 private _sPurchaseAgreementIds = 1;

    /* EXTERNAL FUNCTIONS */

    /// @inheritdoc IPurchaseAgreement
    function setFinancingArrangingIsDissolved(uint256 _purchaseAgreementId)
        external
        override
    {
        /* PERFORM ASSERTIONS */

        // Caller must be the bank.
        if (msg.sender != address(bank())) {
            revert Notary__CallerMustBeBank();
        }

        _sPurchaseAgreements[_purchaseAgreementId]
            .resolutiveConditions
            .financingArranging
            .isDissolved = true;
    }

    /// @inheritdoc IPurchaseAgreement
    function setGuaranteeIsProvided(
        uint256 _purchaseAgreementId,
        TypeOfGuarantee _typeOfGuarantee
    ) external override {
        /* PERFORM ASSERTIONS */

        // Caller must be the bank.
        if (msg.sender != address(bank())) {
            revert Notary__CallerMustBeBank();
        }

        if (_typeOfGuarantee == TypeOfGuarantee.BANK_GUARANTEE) {
            /* ARRANGE */

            // Get bank guarantee or deposit.
            BankGuarantee storage bankGuarantee = _sPurchaseAgreements[
                _purchaseAgreementId
            ].bankGuaranteeOrDeposit.bankGuarantee;

            /* SET GUARANTEE */

            bankGuarantee.dateWhenApproved = block.timestamp;
        }

        if (_typeOfGuarantee == TypeOfGuarantee.DEPOSIT) {
            /* ARRANGE */

            // Get bank guarantee or deposit.
            Deposit storage deposit = _sPurchaseAgreements[_purchaseAgreementId]
                .bankGuaranteeOrDeposit
                .deposit;

            /* SET GUARANTEE */

            deposit.dateWhenDeposited = block.timestamp;
        }

        _sPurchaseAgreements[_purchaseAgreementId]
            .bankGuaranteeOrDeposit
            .typeOfGuarantee = _typeOfGuarantee;
    }

    /// @inheritdoc IPurchaseAgreement
    function setPaymentIsFulfilled(uint256 _purchaseAgreementId)
        external
        override
    {
        /* PERFORM ASSERTIONS */

        // Caller must be the bank.
        if (msg.sender != address(bank())) {
            revert Notary__CallerMustBeBank();
        }

        _sPurchaseAgreements[_purchaseAgreementId].payment.isFulfilled = true;
    }

    /// @inheritdoc IPurchaseAgreement
    function setStructuralInspectionIsDissolved(uint256 _purchaseAgreementId)
        external
        override
    {
        /* PERFORM ASSERTIONS */

        // Caller must be the inspector.
        if (msg.sender != address(inspector())) {
            revert Notary__CallerMustBeInspector();
        }

        _sPurchaseAgreements[_purchaseAgreementId]
            .resolutiveConditions
            .structuralInspection
            .isDissolved = true;
    }

    /* EXTERNAL VIEW FUNCTIONS */

    /// @inheritdoc IPurchaseAgreement
    function getPurchaseAgreement(uint256 _purchaseAgreementId)
        external
        view
        override
        returns (PurchaseAgreementStruct memory)
    {
        return _sPurchaseAgreements[_purchaseAgreementId];
    }

    /* INTERNAL FUNCTIONS */

    function _drawUpPurchaseAgreement(
        PurchaseAgreementStruct memory _purchaseAgreement
    ) internal {
        /* ARRANGE */

        // Get token ID.
        uint256 tokenId = _purchaseAgreement
            .sellAndPurchase
            .immovableProperty
            .tokenId;

        // Get an available purchase agreement ID.
        uint256 id = _sPurchaseAgreementIds;

        /* PERFORM ASSERTIONS */

        // Make sure that the listing params are identical to purchase agreement
        // params.
        _validateListingPurchaseAgreementParams(tokenId, _purchaseAgreement);

        // Make sure that the `_purchaseAgreement` is valid.
        _validatePurchaseAgreement(_purchaseAgreement);

        /* DRAW UP PURCHASE AGREEMENT */

        _purchaseAgreement.id = id;
        _sPurchaseAgreements[id] = _purchaseAgreement;

        // Set listing as sold in Truhuis Marketplace.
        trade().setListingSold(tokenId);

        _sPurchaseAgreementIds++;
    }

    /* PRIVATE FUNCTIONS */

    function _validateListingPurchaseAgreementParams(
        uint256 _tokenId,
        PurchaseAgreementStruct memory _purchaseAgreement
    ) private view {
        /* ARRANGE */

        // Get listing.
        Listing memory listing = trade().getListing(_tokenId);

        // Get buyer.
        address buyer = _purchaseAgreement.identity.buyer.account;

        // Get payment currency.
        address currency = _purchaseAgreement.payment.currency;

        // Get seller.
        address seller = _purchaseAgreement.identity.seller.account;

        // Get token ID of the immovable property.
        uint256 tokenId = _purchaseAgreement
            .sellAndPurchase
            .immovableProperty
            .tokenId;

        /* PERFORM ASSERTIONS */

        // Listing must be existent.
        if (!listing.exists) {
            revert LISTING_NOT_EXISTS(_tokenId);
        }

        // Listing stage must be at `NEGOTIATION` stage.
        if (listing.stage != Stage.NEGOTIATION) {
            revert INVALID_STAGE(Stage.NEGOTIATION, listing.stage);
        }

        // Token IDs must be identical.
        if (_tokenId != tokenId) {
            revert TOKEN_IDS_NOT_IDENTICAL(tokenId, _tokenId);
        }

        // Buyers must be identical.
        if (buyer != listing.acceptedOffer.offerer) {
            revert BUYERS_NOT_IDENTICAL(buyer, listing.acceptedOffer.offerer);
        }

        // Currencies must be identical.
        if (currency != listing.acceptedOffer.currency) {
            revert CURRENCIES_NOT_IDENTICAL(
                currency,
                listing.acceptedOffer.currency
            );
        }

        // Sellers must be identical.
        if (seller != listing.seller) {
            revert SELLERS_NOT_IDENTICAL(seller, listing.seller);
        }
    }

    function _validatePurchaseAgreement(
        PurchaseAgreementStruct memory _purchaseAgreement
    ) private view {
        // Article 1
        _validateSellAndPurchase(_purchaseAgreement.sellAndPurchase);
        // Article 2
        _validateCosts(_purchaseAgreement.costs);
        // Article 3
        _validatePayment(_purchaseAgreement.payment);
        // Article 4
        _validateTransferOfOwnership(_purchaseAgreement.transferOfOwnership);
        // Article 5
        _validateBankGuaranteeOrDeposit(
            _purchaseAgreement.sellAndPurchase.immovableProperty.price,
            _purchaseAgreement.bankGuaranteeOrDeposit
        );
        // Article 14
        _validateIdentity(
            _purchaseAgreement.sellAndPurchase.immovableProperty.tokenId,
            _purchaseAgreement.identity
        );
        // Article 15
        _validateResolutiveConditions(_purchaseAgreement.resolutiveConditions);
        // Article 16
        _validateCoolingOffPeriod(_purchaseAgreement.coolingOffPeriod);
        // Article 17
        _validateWrittenRecord(_purchaseAgreement.writtenRecord);
        // Article 18
        _validateDutchLaw(_purchaseAgreement.dutchLaw);
    }
}
