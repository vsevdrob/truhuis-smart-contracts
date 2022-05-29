from brownie import TruhuisMarketplace, network

from helper_brownie import CHAINS, get_account, move_blocks
from helper_truhuis import CURRENCY_REGISTRY


def withdraw_seller_proceeds(_seller: str, _currency: str, _marketplace=None):
    seller = get_account(wallet=_seller)
    currency = CURRENCY_REGISTRY[_currency]
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]

    tx = marketplace.withdrawSellerProceeds(currency, {"from": seller})
    tx.wait(1)

    if network.show_active() in CHAINS["local"]:
        move_blocks()


def main():
    withdraw_seller_proceeds(
        _seller=input("Seller (e.g. citizen_usa_1): "),
        _currency=input("Currency (e.g. USDT): "),
    )
