// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "./ATruhuisBank.sol";

contract TruhuisBank is ATruhuisBank {
    constructor(address _addressRegistry) ATruhuisBank(_addressRegistry) {}

    /// @inheritdoc ITruhuisBank
    function fulfillGuarantee(
        uint256 _purchaseAgreementId,
        TypeOfGuarantee _typeOfGuarantee
    ) external override {
        _fulfillGuarantee(_purchaseAgreementId, _typeOfGuarantee);
    }

    /// @inheritdoc ITruhuisBank
    function fulfillPayment(uint256 _purchaseAgreementId) external override {
        _fulfillPayment(_purchaseAgreementId);
    }

    /// @inheritdoc ITruhuisBank
    function takeOutMortgage(uint256 _purchaseAgreementId) external override {
        _takeOutMortgage(_purchaseAgreementId);
    }

    /// @inheritdoc ITruhuisBank
    function unlockProceeds(uint256 _purchaseAgreementId) external override {
        _unlockProceeds(_purchaseAgreementId);
    }

    /// @inheritdoc ITruhuisBank
    function withdrawProceeds(address _currency) external override {
        _withdrawProceeds(_currency);
    }
}
