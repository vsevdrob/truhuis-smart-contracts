from brownie import TruhuisMarketplace
from brownie.convert import to_bytes

from helper_brownie import get_account


def check_upkeep(_keeper: str, _check_data: int, _marketplace=None):

    """
    @notice Check whether cooling-off period is expired.
    """

    keeper = get_account(wallet=_keeper)
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]

    check_data = to_bytes(_check_data, "bytes32")

    upkeepNeeded, performData = marketplace.checkUpkeep.call(check_data, {"from": keeper})

    print(f"The status of this upkeep is currently: {upkeepNeeded}")
    print(f"Here is the perform data: {performData}")

    return upkeepNeeded, performData


def main():
    check_upkeep(
        _keeper=input("Keeper  (e.g. chainlink_keeper): "),
        _check_data=int(input("tokenId of the NFT: ")),
    )
