// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import {
    SellAndPurchase__ItemsPriceMustBeGreaterThanZero,
    SellAndPurchase__ListOfItemsIsEmpty,
    SellAndPurchase__PurchasePriceMustBeGreaterThanZero,
    SellAndPurchase__TokenNotExists,
    SellAndPurchase
} from "@interfaces/IPurchaseAgreement.sol";
import "@core/addresser/TruhuisAddresserAPI.sol";

contract Article01SellAndPurchase is TruhuisAddresserAPI {
    function _validateSellAndPurchase(SellAndPurchase memory _sellAndPurchase)
        internal
        view
    {
        /* ARRANGE */

        // Get list of items that are the movable properties.
        //string memory listOfItems = _sellAndPurchase.movableProperties.listOfItems;

        // Get items price of the movable properties.
        uint256 itemsPrice = _sellAndPurchase.movableProperties.price;

        // Get token ID of the immovable property.
        uint256 tokenId = _sellAndPurchase.immovableProperty.tokenId;

        // Get purchase price of the immovable property.
        uint256 purchasePrice = _sellAndPurchase
            .immovableProperty
            .price;

        /* PERFORM ASSERTIONS */

        // List of items must be not an empty string.
        //if () {
        //    revert SellAndPurchase__ListOfItemsIsEmpty();
        //}

        // Price of the items must be greater than zero.
        if (0 >= itemsPrice) {
            revert SellAndPurchase__ItemsPriceMustBeGreaterThanZero();
        }

        // NFT must be existent.
        if (!cadastre().exists(tokenId)) {
            revert SellAndPurchase__TokenNotExists(tokenId);
        }

        if (0 >= purchasePrice) {
            revert SellAndPurchase__PurchasePriceMustBeGreaterThanZero();
        }
    }
}
