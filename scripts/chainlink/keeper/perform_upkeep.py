from brownie import TruhuisMarketplace
from brownie.convert.main import to_bytes

from helper_brownie import get_account
from scripts.chainlink.keeper.check_upkeep import check_upkeep


def perform_upkeep(_keeper: str, _check_data: int, _marketplace=None):
    keeper = get_account(wallet=_keeper)
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]

    upkeep_needed, perform_data = check_upkeep(_keeper, _check_data, marketplace)

    if upkeep_needed == True:
        tx = marketplace.performUpkeep(to_bytes(_check_data, "bytes32"), {"from": keeper})
        tx.wait(1)

        print("Performed Upkeep!")

        return True

    else:
        print("Failed to perform upkeep.")
        return False


def main():
    perform_upkeep(_keeper="chainlink_keeper", _check_data=int(input("Token ID: ")))
