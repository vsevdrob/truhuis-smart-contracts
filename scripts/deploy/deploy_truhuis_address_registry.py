from brownie import TruhuisAddressRegistry

from helper_brownie import (
    BLOCK_CONFIRMATIONS_FOR_VERIFICATION,
    get_account,
    is_verifiable_contract,
)


def deploy():
    deployer = get_account(wallet="truhuis")

    address_registry = TruhuisAddressRegistry.deploy({"from": deployer})

    if is_verifiable_contract():
        address_registry.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        TruhuisAddressRegistry.publish_source(address_registry)

    return address_registry


def main():
    deploy()
