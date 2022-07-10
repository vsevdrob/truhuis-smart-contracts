// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@interfaces/ITaxAdministration.sol";

/**
 * @title TaxAdministration
 * @author vsevdrob
 * @notice _
 */
contract TaxAdministration is Ownable, ITaxAdministration {
    // e.g. 100 (1%); 1000 (10%)
    mapping(uint256 => uint96) internal _sTransferTaxById;

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
    function transferTax(/*address _buyer, uint256 _tokenId*/)
        public
        view
        override
        returns (uint96)
    {
        // For now just return a basic tariff.
        return _sTransferTaxById[0];
    }
}
