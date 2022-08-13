// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

error COOLING_OFF_PERIOD_NOT_EXPIRED();
error PAYMENT_NOT_FULFILLED();
error INVALID_PURCHASE_AGREEMENT();
error RESOLUTIVE_CONDITIONS_NOT_DISSOLVED();

struct DeedOfDeliveryStruct {
    bool isFulfilled;
    uint256 deedOfDeliveryId;
    uint256 purchaseAgreementId;
    uint256 tokenId;
    uint256 transactionId;
}

interface IDeedOfDelivery {}
