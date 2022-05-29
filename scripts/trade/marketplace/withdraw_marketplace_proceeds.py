from brownie import TruhuisMarketplace, network

from helper_brownie import CHAINS, get_account, move_blocks
from helper_truhuis import CURRENCY_REGISTRY


def withdraw_marketplace_proceeds(_marketplace_owner: str, _currency: str, _marketplace=None):
    owner = get_account(wallet=_marketplace_owner)
    currency = CURRENCY_REGISTRY[_currency]
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]

    tx = marketplace.withdrawMarketplaceProceeds(currency, {"from": owner})
    tx.wait(1)

    if network.show_active() in CHAINS["local"]:
        move_blocks()


def main():
    withdraw_marketplace_proceeds(
        _marketplace_owner=input("Marketplace owner (e.g. truhuis): "),
        _currency=input("Currency (e.g. USDT): "),
    )
