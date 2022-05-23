from brownie import TruhuisCurrencyRegistry

from helper_brownie import (
    BLOCK_CONFIRMATIONS_FOR_VERIFICATION,
    get_account,
    is_verifiable_contract,
)


def deploy():
    deployer = get_account(wallet="truhuis")

    currency_registry = TruhuisCurrencyRegistry.deploy({"from": deployer})

    if is_verifiable_contract():
        currency_registry.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        TruhuisCurrencyRegistry.publish_source(currency_registry)

    return currency_registry


def main():
    deploy()
