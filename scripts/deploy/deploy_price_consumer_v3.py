from brownie import PriceConsumerV3

from helper_brownie import (
    BLOCK_CONFIRMATIONS_FOR_VERIFICATION,
    get_account,
    is_verifiable_contract,
)
from helper_brownie import get_account


def deploy(_pair: str, _proxy: str, _deployer=None) -> None:
    deployer = _deployer if _deployer else get_account(wallet="truhuis")
    price_consumer_v3 = PriceConsumerV3.deploy(_pair, _proxy, {"from": deployer})

    if is_verifiable_contract():
        price_consumer_v3.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        PriceConsumerV3.publish_source(price_consumer_v3)

    return price_consumer_v3


def main():
    print("Deploying from truhuis account...")
    deploy(
        _deployer="",
        _pair=input("Pair (e.g. ETH/USDT): "),
        _proxy=input("Chainlink price feed proxy address: "),
    )
