// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "@interfaces/IMunicipality.sol";
import "@interfaces/IPersonalRecordsDatabase.sol";
import "@interfaces/ITaxAdministration.sol";
import "@interfaces/ITruhuisAddresser.sol";
import "@interfaces/ITruhuisAppraiser.sol";
import "@interfaces/ITruhuisAuction.sol";
import "@interfaces/ITruhuisBank.sol";
import "@interfaces/ITruhuisCadastre.sol";
import "@interfaces/ITruhuisInspector.sol";
import "@interfaces/ITruhuisNotary.sol";
import "@interfaces/ITruhuisTrade.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title TruhuisAddresserAPI
/// @notice This contract must be inheritted in order to be able to perform the
///         necessary smart contract function calls in the most convenient way.
abstract contract TruhuisAddresserAPI is Ownable {
    /// @notice Truhuis Addresser smart contract address.
    ITruhuisAddresser private _addresser;

    /// @notice Event emitted when an addresser update occurs.
    event AddresserUpdated(address contractAddr);

    /// @notice Update Truhuis Addresser smart contract address.
    /// @param _newAddr The new Truhuis Addresser smart contract
    ///        address.
    /// @dev Only owner is able to call this function.
    function updateAddresser(address _newAddr) public virtual onlyOwner {
        _addresser = ITruhuisAddresser(_newAddr);
        emit AddresserUpdated(_newAddr);
    }

    /// @notice Returns Truhuis Addresser smart contract interface.
    function addresser()
        public
        view
        virtual
        returns (ITruhuisAddresser)
    {
        return _addresser;
    }

    /// @notice Returns Truhuis Appraiser smart contract interface.
    function appraiser() public view virtual returns (ITruhuisAppraiser) {
        return
            ITruhuisAppraiser(
                _addresser.getAddress(bytes32("APPRAISER"))
            );
    }

    /// @notice Returns Truhuis Bank smart contract interface.
    function bank() public view virtual returns (ITruhuisBank) {
        return ITruhuisBank(_addresser.getAddress(bytes32("BANK")));
    }

    /// @notice Returns Truhuis Cadastre smart contract interface.
    function cadastre() public view virtual returns (ITruhuisCadastre) {
        return
            ITruhuisCadastre(_addresser.getAddress(bytes32("CADASTRE")));
    }

    /// @notice Returns Truhuis Inspector smart contract interface.
    function inspector() public view virtual returns (ITruhuisInspector) {
        return
            ITruhuisInspector(
                _addresser.getAddress(bytes32("INSPECTOR"))
            );
    }

    function municipality(address _addr)
        public
        view
        virtual
        returns (IMunicipality)
    {
        return IMunicipality(_addr);
    }

    /// @notice _
    function notary() public view virtual returns (ITruhuisNotary) {
        return ITruhuisNotary(_addresser.getAddress(bytes32("NOTARY")));
    }

    /// @notice Returns Personal Records Database smart contract interface.
    function personalRecordsDatabase()
        public
        view
        virtual
        returns (IPersonalRecordsDatabase)
    {
        return
            IPersonalRecordsDatabase(
                _addresser.getAddress(
                    bytes32("PERSONAL RECORDS DATABASE")
                )
            );
    }

    /// @notice Returns Tax Administration smart contract interface.
    function taxAdministration()
        public
        view
        virtual
        returns (ITaxAdministration)
    {
        return
            ITaxAdministration(
                _addresser.getAddress(bytes32("TAX ADMINISTRATION"))
            );
    }

    /// @notice Returns Truhuis Marketplace smart contract interface.
    function trade() public view virtual returns (ITruhuisTrade) {
        return
            ITruhuisTrade(_addresser.getAddress(bytes32("TRADE")));
    }
}
