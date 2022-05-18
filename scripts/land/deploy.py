from brownie import TruhuisLandRegistry, TruhuisAddressRegistry
from helper_brownie import BLOCK_CONFIRMATIONS_FOR_VERIFICATION, get_account, is_verifiable_contract


def deploy():
    deployer = get_account(wallet="truhuis")

    land_registry = TruhuisLandRegistry.deploy()
