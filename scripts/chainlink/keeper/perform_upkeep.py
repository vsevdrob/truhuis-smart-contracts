from brownie import TruhuisMarketplace, network
from brownie.convert.main import to_bytes
from brownie.network.web3 import Web3

from helper_brownie import CHAINS, get_account
from scripts.chainlink.keeper.check_upkeep import check_upkeep


def perform_upkeep(_chainlink_keeper, _check_data: int, _marketplace=None):
    keeper = _chainlink_keeper if _chainlink_keeper else get_account(wallet="chainlink_keeper")
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]

    upkeep_needed, perform_data = check_upkeep(keeper, _check_data, marketplace)

    if upkeep_needed == True:
        tx = marketplace.performUpkeep(to_bytes(_check_data, "bytes32"), {"from": keeper})
        tx.wait(1)

        print("Performed Upkeep!")

        return True

    else:
        print("Failed to perform upkeep.")
        return False
