from brownie import TruhuisAddressRegistry, TruhuisCurrencyRegistry, network

from helper_brownie import get_account


def update_currency_registry(_currency_registry: str = ""):
    truhuis = get_account(wallet="truhuis")
    address_registry = TruhuisAddressRegistry[-1]

    currency_registry = (
        _currency_registry if _currency_registry else TruhuisCurrencyRegistry[-1].address
    )

    print(
        f"Calling TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    tx = address_registry.updateCurrencyRegistry(currency_registry, {"from": truhuis})
    tx.wait(1)

    print(
        f"Updated successfully new TruhuisCurrencyRegistry address on {address_registry.address}\n",
        f"Run the following to read just updated TruhuisCurrencyRegistry address:\n",
        f"brownie run scripts/address/get_currency_registry.py --network {network.show_active()}",
    )


def main():
    update_currency_registry(_currency_registry=input("New TruhuisCurrencyRegistry address: "))
