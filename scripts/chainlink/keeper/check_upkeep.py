from brownie import TruhuisMarketplace
from brownie.convert import to_bytes

from helper_brownie import get_account


def check_upkeep(_chainlink_keeper, _check_data: int, _marketplace=None):

    """
    @notice Check whether cooling-off period is expired.
    """

    keeper = _chainlink_keeper if _chainlink_keeper else get_account(wallet="chainlink_keeper")
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]

    check_data = to_bytes(_check_data, "bytes32")

    upkeepNeeded, performData = marketplace.checkUpkeep.call(check_data, {"from": keeper})

    print(f"The status of this upkeep is currently: {upkeepNeeded}")
    print(f"Here is the perform data: {performData}")

    return upkeepNeeded, performData


def main():
    check_upkeep(
        _chainlink_keeper=get_account(wallet="chainlink_keeper"),
        _check_data=int(input("Truhuis NFT ID: ")),
    )
