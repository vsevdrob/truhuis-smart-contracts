// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {
    PurchaseAgreementStorage as Storage
} from "./PurchaseAgreementStorage.sol";

/**
 * @title PurchaseAgreement
 * @author _
 * @notice If you buy or sell an NFT real estate, the agreements are recorded in
 *         a purchase agreement.
 */
contract PurchaseAgreement is Storage {
    enum Party {
        BUYER,
        SELLER
    }

    struct TransferTax {
        address receiver;
        uint256 amount;
        Party party;
    }

    struct Marketplace {
        address receiver;
        uint256 amount;
        Party party;
    }

    struct Costs {
        TransferTax transferTax;
        Marketplace marketplace;
    }

    struct DeedOfDelivery {
        bool isFulfilled;
        uint256 date;
    }

    struct RealEstate {
        uint256 price;
        uint256 tokenId;
    }

    struct Vault {
        address vault;
    }

    struct ResolutiveConditions {
        bool isDissolved;
        uint256 deadline;
    }

    struct Buyer {
        address buyer;
    }

    struct coolingOffPeriod {
        uint256 deadline;
    }

    /**
     * @notice Article 18
     *         This provision has been included to prevent ambiguity about
     *         parties with different nationalities who are involved in the
     *         purchase agreement. By declaring Dutch law applicable, the Dutch
     *         court has authority to settle any disputes arising from the
     *         purchase agreement.
     */
    struct Law {
        bool isDutchLawApplied;
    }

    struct PurchaseAgreement {
        address buyer;
        address seller;
        uint256 coolingOffPeriod;
        Costs costs;
        DeedOfDelivery deedOfDelivery;
        RealEstate realEstate;
        ResolutiveConditions resolutiveConditions;
    }

    constructor(
        address _buyer,
        address _seller,
        uint256 _tokenId
    ) {
        _sBuyer = _buyer;
        _sSeller = _seller;
    }
}
