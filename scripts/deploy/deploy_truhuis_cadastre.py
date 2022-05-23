from brownie import TruhuisAddressRegistry, TruhuisCadastre

from helper_brownie import (
    BLOCK_CONFIRMATIONS_FOR_VERIFICATION,
    get_account,
    is_verifiable_contract,
)
from helper_truhuis import CADASTRE

# from scripts.cadastre.set_contract_uri import set_contract_uri


def deploy(
    _truhuis=None,
    _address_registry=None,
):
    deployer = _truhuis if _truhuis else get_account(wallet="truhuis")

    address_registry = (
        _address_registry if _address_registry else TruhuisAddressRegistry[-1].address
    )

    cadastre = TruhuisCadastre.deploy(
        CADASTRE["contract_URI"], address_registry, {"from": deployer}
    )

    if is_verifiable_contract():
        cadastre.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        TruhuisCadastre.publish_source(cadastre)

    return cadastre


def main():
    deploy()
