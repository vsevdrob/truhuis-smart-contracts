from brownie import TruhuisAddressRegistry, TruhuisAuction

from helper_brownie import (
    BLOCK_CONFIRMATIONS_FOR_VERIFICATION,
    get_account,
    is_verifiable_contract,
)
from helper_truhuis import AUCTION


def deploy():
    deployer = get_account(wallet="truhuis")

    auction = TruhuisAuction.deploy(
        AUCTION["owner"],
        TruhuisAddressRegistry[-1].address,
        AUCTION["commission"],
        {"from": deployer},
    )

    if is_verifiable_contract():
        auction.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        TruhuisAuction.publish_source(auction)

    return auction


def main():
    deploy()
