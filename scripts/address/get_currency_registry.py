from brownie import TruhuisAddressRegistry, network


def get_currency_registry():
    address_registry = TruhuisAddressRegistry[-1]

    print(
        f"Calling TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    currency_registry_addr = address_registry.currencyRegistry()

    print(
        f"Successfully called {address_registry.address}",
        f"The TruhuisCurrencyRegistry address is {currency_registry_addr}",
    )

    return currency_registry_addr


def main():
    get_currency_registry()
