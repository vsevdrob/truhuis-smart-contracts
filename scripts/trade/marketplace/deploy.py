from brownie import TruhuisAddressRegistry, TruhuisMarketplace

from helper_brownie import (
    BLOCK_CONFIRMATIONS_FOR_VERIFICATION,
    get_account,
    is_verifiable_contract,
)


def deploy():
    deployer = get_account(wallet="truhuis")

    marketplace = TruhuisMarketplace.deploy(TruhuisAddressRegistry[-1].address, {"from": deployer})

    if is_verifiable_contract():
        marketplace.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        TruhuisMarketplace.public_source(marketplace)

    return marketplace


def main():
    deploy()
