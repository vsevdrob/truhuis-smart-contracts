from brownie import TruhuisCurrencyRegistry, network

from helper_brownie import get_account
from helper_truhuis import CURRENCY_REGISTRY


def add(_currency: str = ""):

    """
    @notice Add ERC20 token as the new currency.
    @param _currency Currency symbol (e.g. USDT or EURT).
    """

    truhuis = get_account(wallet="truhuis")
    currency_registry = TruhuisCurrencyRegistry[-1]
    token_addr = CURRENCY_REGISTRY()[_currency]

    print(
        f"Calling TruhuisCurrencyRegistry contract {currency_registry.address} on network {network.show_active()}"
    )

    tx = currency_registry.add(token_addr, {"from": truhuis})
    tx.wait(1)

    print(
        f"Successfully added new ERC20 address to {currency_registry.address}\n",
        f"Run the following to verify just added ERC20 address:\n",
        f"brownie run scripts/currency_registry/is_allowed.py is_allowed {token_addr} --network {network.show_active()}",
    )


def main():
    add(_currency=input("Currency (e.g. EURT or USDT): "))
