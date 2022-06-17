// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import {
    TaxAdministrationStorage as Storage
} from "./TaxAdministrationStorage.sol";
import "../../interfaces/ITaxAdministration.sol";

contract TaxAdministration is Ownable, ITaxAdministration, Storage {
    constructor() {
        updateTransferTax(0, 200);
    }

    /// @inheritdoc ITaxAdministration
    function updateTransferTax(uint256 _id, uint96 _tax)
        public
        override
        onlyOwner
    {
        _sTransferTaxById[_id] = _tax;
        emit TransferTaxUpdated(_id, _tax);
    }

    /// @inheritdoc ITaxAdministration
    function transferTax(address _buyer, uint256 _tokenId)
        public
        view
        override
        returns (uint96)
    {
        // For now just return a basic tariff.
        return _sTransferTaxById[0];
    }
}
