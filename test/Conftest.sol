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
    address public truhuis;
    // Sellers accounts.
    address public alice = address(0x1);
    address public bob = address(0x2);
    address public charlie = address(0x3);
    // Buyers accounts.
    address public dave = address(0x4);
    address public eve = address(0x5);
    address public ferdie = address(0x6);
    // Municipalities accounts.
    address public amsterdam = address(0x7);
    address public rotterdam = address(0x8);
    address public theHague = address(0x9);
    // Ministry of the Interior and Kingdom Relations (IKR).
    address public ministryOfIKR = address(0x10);
    // Ministry of Finance (Fin).
    address public ministryOfFin = address(0x11);

    // Truhuis contracts as well as state and currency contracts.
    TruhuisAddresser public addresser;
    TruhuisAppraiser public appraiser;
    TruhuisBank public bank;
    TruhuisCadastre public cadastre;
    TruhuisInspector public inspector;
    TruhuisNotary public notary;
    MockERC20EURT public mockERC20EURT;
    Municipality public municipalityA;
    Municipality public municipalityR;
    Municipality public municipalityH;
    PersonalRecordsDatabase public personalRecordsDatabase;
    TaxAdministration public taxAdministration;
    TruhuisTrade public trade;

    /// @dev Identifier for the municipality of Amsterdam.
    bytes4 public constant AMSTERDAM = bytes4("0363");
    /// @dev Identifier for the municipality of Rotterdam.
    bytes4 public constant ROTTERDAM = bytes4("0599");
    /// @dev Identifier for the municipality of The Hague.
    bytes4 public constant THE_HAGUE = bytes4("0518");

    /// @dev Identifier for Truhuis Addresser smart contract.
    bytes32 public constant ADDRESSER = "ADDRESSER";
    /// @dev Identifier for Truhuis Appraiser smart contract.
    bytes32 public constant APPRAISER = "APPRAISER";
    /// @dev Identifier for Truhuis Bank smart contract.
    bytes32 public constant BANK = "BANK";
    /// @dev Identifier for Truhuis Cadastre smart contract.
    bytes32 public constant CADASTRE = "CADASTRE";
    /// @dev Identifier for Truhuis Inspector smart contract.
    bytes32 public constant INSPECTOR = "INSPECTOR";
    /// @dev Identifier for Truhuis Notary smart contract.
    bytes32 public constant NOTARY = "NOTARY";
    /// @dev Identifier for Personal Records Database smart contract.
    bytes32 public constant PERSONAL_RECORDS_DATABASE =
        "PERSONAL RECORDS DATABASE";
    /// @dev Identifier for Chainlink Price Feed smart contract.
    bytes32 public constant PRICE_ORACLE = "PRICE ORACLE";
    /// @dev Identifier for Tax Administration smart contract.
    bytes32 public constant TAX_ADMINISTRATION = "TAX ADMINISTRATION";
    /// @dev Identifier for Truhuis Trade smart contract.
    bytes32 public constant TRADE = "TRADE";

    /// @dev Contract URI related to the cadastre.
    string public cadastreContractURI = "ipfs://";
    /// @dev Token URI of token ID 1.
    string public sTokenURI1 = "ipfs://1";
    /// @dev Token URI of token ID 2.
    string public sTokenURI2 = "ipfs://2";

    /// @dev Truhuis Marketplace initial service fee.
    uint96 public sServiceFee = 250; // 2.5 %

    constructor() {
        truhuis = msg.sender;
    }

    function _deploy() internal {
        vm.startPrank(truhuis);
        addresser = new TruhuisAddresser();
        appraiser = new TruhuisAppraiser(address(addresser));
        bank = new TruhuisBank(address(addresser));
        cadastre = new TruhuisCadastre(
            address(addresser),
            cadastreContractURI
        );
        inspector = new TruhuisInspector(address(addresser));
        notary = new TruhuisNotary(address(addresser));
        mockERC20EURT = new MockERC20EURT(truhuis, 1 * 1000000 * 1000000);
        vm.stopPrank();

        vm.startPrank(amsterdam);
        municipalityA = new Municipality(AMSTERDAM);
        vm.stopPrank();

        vm.startPrank(rotterdam);
        municipalityR = new Municipality(ROTTERDAM);
        vm.stopPrank();

        vm.startPrank(theHague);
        municipalityH = new Municipality(THE_HAGUE);
        vm.stopPrank();

        vm.startPrank(ministryOfIKR);
        personalRecordsDatabase = new PersonalRecordsDatabase(
            address(addresser)
        );
        vm.stopPrank();

        vm.startPrank(ministryOfFin);
        taxAdministration = new TaxAdministration();
        vm.stopPrank();

        trade = new TruhuisTrade(address(addresser), 50);

        _refuelAccountsERC20();
    }

    function _refuelAccountsERC20() private {
        vm.startPrank(truhuis);
        // Send EURT to the accounts.
        mockERC20EURT.transfer(alice, 10000000);
        mockERC20EURT.transfer(bob, 10000000);
        mockERC20EURT.transfer(charlie, 10000000);
        mockERC20EURT.transfer(dave, 10000000);
        mockERC20EURT.transfer(eve, 10000000);
        mockERC20EURT.transfer(ferdie, 10000000);
        vm.stopPrank();
    }
}
