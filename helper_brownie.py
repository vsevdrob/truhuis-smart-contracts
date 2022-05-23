from brownie import accounts, config, network
from brownie import (
    LinkToken,
    MockERC20EURT,
    MockERC20USDT,
    MockOracle,
    MockV3AggregatorEURUSD,
    VRFCoordinatorV2Mock,
    accounts,
    config,
    network,
    web3,
)
from brownie.network.web3 import Web3

CHAINS = {
    "local": ["ganache-local", "development", "hardhat", "localhost"],
    "test": ["rinkeby", "kovan", "mumbai"],
    "main": ["mainnet", "polygon"],
}


BLOCK_CONFIRMATIONS_FOR_VERIFICATION: int = 1 if network.show_active() in CHAINS["local"] else 6


def is_verifiable_contract() -> bool:
    return config["networks"][network.show_active()].get("verify", False)


def get_account(index=None, id=None, wallet: str = ""):
    """Return current user account."""
    if index and (network.show_active() in CHAINS["local"]):
        return accounts[index]
    elif id:
        return accounts.load(id)
    elif wallet:
        return accounts.add(config["wallets"][network.show_active()][wallet])
    elif network.show_active() in CHAINS["local"]:
        return accounts[0]


def get_mock(_path_1: str, _path_2: str, _path_3: str = "", _path_4: str = ""):

    if network.show_active() in CHAINS["local"] or network.show_active() in CHAINS["test"]:
        MOCK = {
            "chainlink": {
                "api_consumer": {
                    "link_token": LinkToken,
                    "0": {
                        "oracle": MockOracle,
                    },
                },
                "price_consumer_v3": {
                    "0": {
                        "proxy": MockV3AggregatorEURUSD,
                    }
                },
                "vrf_coordinator_v2": {"0": {"vrf_coordinator": VRFCoordinatorV2Mock}},
            },
            "truhuis": {
                "currency_registry": {
                    "EURT": MockERC20EURT,
                    "USDT": MockERC20USDT,
                },
            },
        }

        if _path_4 != "":
            contract_type = MOCK[_path_1][_path_2][_path_3][_path_4]
        else:
            contract_type = MOCK[_path_1][_path_2][_path_3]

        if len(contract_type) <= 0:
            deploy_mocks()

        contract = contract_type[-1]

        return contract


DECIMALS = 8
INITIAL_VALUE = web3.toWei(1.05, "ether")
BASE_FEE = 100000000000000000  # The premium
GAS_PRICE_LINK = 1e9  # Some value calculated depending on the Layer 1 cost and Link

TOTAL_SUPPLY_EURT = Web3.toWei(10**10, "ether")  # 10 billion of Euro token
TOTAL_SUPPLY_USDT = Web3.toWei(10**10, "ether")  # 10 billion of USD token


def deploy_mocks():
    """
    Use this script if you want to deploy mocks to a testnet or to a local network.
    """

    truhuis = get_account(wallet="truhuis")

    citizen_nld_1 = config["networks"][network.show_active()]["citizen_nld_1"]
    citizen_nld_2 = config["networks"][network.show_active()]["citizen_nld_2"]
    citizen_nld_3 = config["networks"][network.show_active()]["citizen_nld_3"]
    citizen_usa_1 = config["networks"][network.show_active()]["citizen_usa_1"]
    citizen_usa_2 = config["networks"][network.show_active()]["citizen_usa_2"]
    citizen_usa_3 = config["networks"][network.show_active()]["citizen_usa_3"]

    print(f"The active network is {network.show_active()}")
    print("Deploying Mocks...")

    print("Deploying Mock ERC20 EURT...")
    mock_erc20_eurt = MockERC20EURT.deploy(truhuis, TOTAL_SUPPLY_EURT, {"from": truhuis})
    print(f"Deployed to {mock_erc20_eurt.address}")
    print("Transfering Euro tokens to the Dutch residents...")
    tx = mock_erc20_eurt.transfer(citizen_nld_1, TOTAL_SUPPLY_EURT / 10, {"from": truhuis})
    tx.wait(1)
    tx = mock_erc20_eurt.transfer(citizen_nld_2, TOTAL_SUPPLY_EURT / 10, {"from": truhuis})
    tx.wait(1)
    tx = mock_erc20_eurt.transfer(citizen_nld_3, TOTAL_SUPPLY_EURT / 10, {"from": truhuis})
    tx.wait(1)
    print("Transfered Euro tokens to Dutch citizens.")

    print("Deploying Mock ERC20 USDT...")
    mock_erc20_usdt = MockERC20USDT.deploy(truhuis, TOTAL_SUPPLY_USDT, {"from": truhuis})
    print(f"Deployed to {mock_erc20_usdt.address}")
    print("Transfering USD tokens to the American residents...")
    tx = mock_erc20_usdt.transfer(citizen_usa_1, TOTAL_SUPPLY_USDT / 10, {"from": truhuis})
    tx.wait(1)
    tx = mock_erc20_usdt.transfer(citizen_usa_2, TOTAL_SUPPLY_USDT / 10, {"from": truhuis})
    tx.wait(1)
    tx = mock_erc20_usdt.transfer(citizen_usa_3, TOTAL_SUPPLY_USDT / 10, {"from": truhuis})
    tx.wait(1)
    print("Transfered USD tokens to American citizens.")

    if network.show_active() in CHAINS["local"]:
        # print("Deploying Mock Link Token...")
        # link_token = LinkToken.deploy({"from": truhuis})
        # print(f"Deployed to {link_token.address}")

        print("Deploying Mock Price Feed EUR/USD...")
        mock_price_feed = MockV3AggregatorEURUSD.deploy(DECIMALS, INITIAL_VALUE, {"from": truhuis})
        print(f"Deployed to {mock_price_feed.address}")

        # print("Deploying Mock VRFCoordinator...")
        # mock_vrf_coordinator = VRFCoordinatorV2Mock.deploy(BASE_FEE, GAS_PRICE_LINK, {"from": truhuis})
        # print(f"Deployed to {mock_vrf_coordinator.address}")

        # print("Deploying Mock Oracle...")
        # mock_oracle = MockOracle.deploy(link_token.address, {"from": truhuis})
        # print(f"Deployed to {mock_oracle.address}")

    print("Mocks Deployed!")


def get_event_value(_tx, _event_name: str, _key: str):
    return _tx.events[_event_name][_key]
