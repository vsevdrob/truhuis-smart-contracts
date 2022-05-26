from brownie import TruhuisCurrencyRegistry, network

from helper_brownie import get_account


def add(_token_addr: str = ""):

    """
    @notice Add ERC20 token as the new currency.
    @param _token_addr ERC20 token address.
    """

    truhuis = get_account(wallet="truhuis")
    currency_registry = TruhuisCurrencyRegistry[-1]

    print(
        f"Calling TruhuisCurrencyRegistry contract {currency_registry.address} on network {network.show_active()}"
    )

    tx = currency_registry.add(_token_addr, {"from": truhuis})
    tx.wait(1)

    print(
        f"Successfully added new ERC20 address to {currency_registry.address}\n",
        f"Run the following to verify just added ERC20 address:\n",
        f"brownie run scripts/currency_registry/is_allowed.py is_allowed {_token_addr} --network {network.show_active()}",
    )


def main():
    add(_token_addr=input("ERC20 token address: "))
