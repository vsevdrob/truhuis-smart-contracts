// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@core/addresser/TruhuisAddresserAPI.sol";
import "@interfaces/ITaxAdministration.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ATaxAdministration
 * @author vsevdrob
 * @notice _
 */
abstract contract ATaxAdministration is
    Ownable,
    ITaxAdministration,
    TruhuisAddresserAPI
{
    /// @dev Tax ID => % (e.g. 100 (1%); 1000 (10%))
    mapping(uint256 => uint96) private _sTaxById;

    constructor(address _addresser) {
        updateAddresser(_addresser);
    }

    /// @inheritdoc ITaxAdministration
    function getTax(uint256 _id)
        external
        view
        override
        returns (uint96)
    {
        return _sTaxById[_id];
    }

    /**
     * @dev _
     */
    function _updateTax(uint256 _id, uint96 _tax)
        internal
        onlyOwner
    {
        _sTaxById[_id] = _tax;
        emit TaxUpdated(_id, _tax);
    }
}

