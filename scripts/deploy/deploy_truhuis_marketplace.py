from brownie import TruhuisAddressRegistry, TruhuisMarketplace

from helper_brownie import (
    BLOCK_CONFIRMATIONS_FOR_VERIFICATION,
    get_account,
    is_verifiable_contract,
)


def deploy(_address_registry_addr: str):
    deployer = get_account(wallet="truhuis")
    address_registry_addr = (
        _address_registry_addr if _address_registry_addr else TruhuisAddressRegistry[-1].address
    )

    marketplace = TruhuisMarketplace.deploy(address_registry_addr, {"from": deployer})

    if is_verifiable_contract():
        marketplace.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        TruhuisMarketplace.publish_source(marketplace)

    return marketplace


def main():
    deploy(_address_registry_addr=input("TruhuisAddressRegistry address: "))
