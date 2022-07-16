// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "@core/addresser/TruhuisAddresser.sol";
import "@core/appraiser/TruhuisAppraiser.sol";
import "@core/bank/TruhuisBank.sol";
import "@core/cadastre/TruhuisCadastre.sol";
import "@core/inspector/TruhuisInspector.sol";
import "@core/notary/TruhuisNotary.sol";
import "@core/state/Municipality.sol";
import "@core/state/PersonalRecordsDatabase.sol";
import "@core/state/TaxAdministration.sol";
import "@core/trade/TruhuisTrade.sol";
import "@mocks/MockERC20EURT.sol";
import "@interfaces/IPersonalRecordsDatabase.sol";
import "@interfaces/IPurchaseAgreement.sol";

/**
 * @title Conftest
 * @author vsevdrob
 * @notice Configurations for tests.
 */
contract Conftest is Test {
    // Truhuis account.
    address public sTruhuis;
    // Sellers accounts.
    address public sAlice = address(0x1);
    address public sBob = address(0x2);
    address public sCharlie = address(0x3);
    // Buyers accounts.
    address public sDave = address(0x4);
    address public sEve = address(0x5);
    address public sFerdie = address(0x6);
    // Municipalities accounts.
    address public sAmsterdam = address(0x7);
    address public sRotterdam = address(0x8);
    address public sTheHague = address(0x9);
    // Ministry of the Interior and Kingdom Relations (IKR).
    address public sMinistryOfIKR = address(0x10);
    // Ministry of Finance (Fin).
    address public sMinistryOfFin = address(0x11);

    // Truhuis contracts as well as state and currency contracts.
    TruhuisAddresser public sAddresser;
    TruhuisAppraiser public sAppraiser;
    TruhuisBank public sBank;
    TruhuisCadastre public sCadastre;
    TruhuisInspector public sInspector;
    TruhuisNotary public sNotary;
    MockERC20EURT public sMockERC20EURT;
    Municipality public sMunicipalityA;
    Municipality public sMunicipalityR;
    Municipality public sMunicipalityH;
    PersonalRecordsDatabase public sPersonalRecordsDatabase;
    TaxAdministration public sTaxAdministration;
    TruhuisTrade public sTrade;

    /// @dev Identifier for the municipality of Amsterdam.
    bytes4 public constant S_AMSTERDAM = bytes4("0363");
    /// @dev Identifier for the municipality of Rotterdam.
    bytes4 public constant S_ROTTERDAM = bytes4("0599");
    /// @dev Identifier for the municipality of The Hague.
    bytes4 public constant S_THE_HAGUE = bytes4("0518");

    /// @dev Identifier for Truhuis Addresser smart contract.
    bytes32 public constant S_ADDRESSER = "ADDRESSER";
    /// @dev Identifier for Truhuis Appraiser smart contract.
    bytes32 public constant S_APPRAISER = "APPRAISER";
    /// @dev Identifier for Truhuis Bank smart contract.
    bytes32 public constant S_BANK = "BANK";
    /// @dev Identifier for Truhuis Cadastre smart contract.
    bytes32 public constant S_CADASTRE = "CADASTRE";
    /// @dev Identifier for Truhuis Inspector smart contract.
    bytes32 public constant S_INSPECTOR = "INSPECTOR";
    /// @dev Identifier for Truhuis Notary smart contract.
    bytes32 public constant S_NOTARY = "NOTARY";
    /// @dev Identifier for Personal Records Database smart contract.
    bytes32 public constant S_PERSONAL_RECORDS_DATABASE =
        "PERSONAL RECORDS DATABASE";
    /// @dev Identifier for Chainlink Price Feed smart contract.
    bytes32 public constant S_PRICE_ORACLE = "PRICE ORACLE";
    /// @dev Identifier for Tax Administration smart contract.
    bytes32 public constant S_TAX_ADMINISTRATION = "TAX ADMINISTRATION";
    /// @dev Identifier for Truhuis Trade smart contract.
    bytes32 public constant S_TRADE = "TRADE";

    /// @dev Contract URI related to the cadastre.
    string public sCadastreContractURI = "ipfs://";
    /// @dev Token URI of token ID 1.
    string public sTokenURI1 = "ipfs://1";
    /// @dev Token URI of token ID 2.
    string public sTokenURI2 = "ipfs://2";

    /// @dev Truhuis Marketplace initial service fee.
    uint96 public sServiceFee = 250; // 2.5 %

    /// @dev Transfer tax ID one.
    uint256 public sTaxIdOne = 1;
    /// @dev Transfer tax amount in % (e.g. 100 = 1%; 1000 = 10%)
    uint96 public sTransferTaxBasis = 200;

    constructor() {
        sTruhuis = msg.sender;
    }

    function _deploy() internal {
        vm.startPrank(sTruhuis);
        sAddresser = new TruhuisAddresser();
        sAppraiser = new TruhuisAppraiser(address(sAddresser));
        sBank = new TruhuisBank(address(sAddresser));
        sCadastre = new TruhuisCadastre(
            address(sAddresser),
            sCadastreContractURI
        );
        sInspector = new TruhuisInspector(address(sAddresser));
        sNotary = new TruhuisNotary(address(sAddresser));
        sMockERC20EURT = new MockERC20EURT(sTruhuis, 1 * 1000000 * 1000000);
        vm.stopPrank();

        vm.startPrank(sAmsterdam);
        sMunicipalityA = new Municipality(S_AMSTERDAM);
        vm.stopPrank();

        vm.startPrank(sRotterdam);
        sMunicipalityR = new Municipality(S_ROTTERDAM);
        vm.stopPrank();

        vm.startPrank(sTheHague);
        sMunicipalityH = new Municipality(S_THE_HAGUE);
        vm.stopPrank();

        vm.startPrank(sMinistryOfIKR);
        sPersonalRecordsDatabase = new PersonalRecordsDatabase(
            address(sAddresser)
        );
        vm.stopPrank();

        vm.startPrank(sMinistryOfFin);
        sTaxAdministration = new TaxAdministration(
            address(sAddresser)
        );
        vm.stopPrank();

        vm.startPrank(sTruhuis);
        sTrade = new TruhuisTrade(address(sAddresser), sServiceFee);
        vm.stopPrank();

        _refuelAccountsERC20();
    }

    function _updateAddresses() internal {
        vm.startPrank(sTruhuis);
        sAddresser.registerMunicipality(address(sMunicipalityA), S_AMSTERDAM);
        sAddresser.registerMunicipality(address(sMunicipalityR), S_ROTTERDAM);
        sAddresser.registerMunicipality(address(sMunicipalityH), S_THE_HAGUE);
        sAddresser.updateAddress(address(sAppraiser), S_APPRAISER);
        sAddresser.updateAddress(address(sBank), S_BANK);
        sAddresser.updateAddress(address(sCadastre), S_CADASTRE);
        sAddresser.updateAddress(address(sInspector), S_INSPECTOR);
        sAddresser.updateAddress(address(sNotary), S_NOTARY);
        sAddresser.updateAddress(
            address(sPersonalRecordsDatabase),
            S_PERSONAL_RECORDS_DATABASE
        );
        sAddresser.updateAddress(
            address(sTaxAdministration),
            S_TAX_ADMINISTRATION
        );
        sAddresser.updateAddress(address(sTrade), S_TRADE);
        vm.stopPrank();
    }

    function _updateTax() internal {
        vm.startPrank(sMinistryOfFin);
        sTaxAdministration.updateTax(sTaxIdOne, sTransferTaxBasis);
        vm.stopPrank();
    }

    function _refuelAccountsERC20() private {
        vm.startPrank(sTruhuis);
        // Send EURT to the accounts.
        sMockERC20EURT.transfer(sAlice, 10000000);
        sMockERC20EURT.transfer(sBob, 10000000);
        sMockERC20EURT.transfer(sCharlie, 10000000);
        sMockERC20EURT.transfer(sDave, 10000000);
        sMockERC20EURT.transfer(sEve, 10000000);
        sMockERC20EURT.transfer(sFerdie, 10000000);
        vm.stopPrank();
    }
}
