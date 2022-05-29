from brownie import TruhuisMarketplace, network

from helper_brownie import CHAINS, get_account, move_blocks
from helper_truhuis import CURRENCY_REGISTRY


def withdraw_transfer_taxes(_receiver: str, _currency: str, _marketplace=None):
    receiver = get_account(wallet=_receiver)
    currency = CURRENCY_REGISTRY[_currency]
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]

    tx = marketplace.withdrawTransferTaxes(currency, {"from": receiver})
    tx.wait(1)

    if network.show_active() in CHAINS["local"]:
        move_blocks()


def main():
    withdraw_transfer_taxes(
        _receiver=input("Transfer tax receiver (e.g. state_government_usa): "),
        _currency=input("Currency (e.g. USDT): "),
    )
