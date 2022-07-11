// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@core/addresser/TruhuisAddresserAPI.sol";
import "@interfaces/IMunicipality.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AMunicipality
 * @author vsevdrob
 * @notice _
 */
abstract contract AMunicipality is
    Ownable,
    IMunicipality,
    TruhuisAddresserAPI
{
    bytes4 private _sId;

    constructor(bytes4 _id) {
        _sId = _id;
    }

    /// @inheritdoc IMunicipality
    function getId() external view override returns (bytes4) {
        return _sId;
    }
}
