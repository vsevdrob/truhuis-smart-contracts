from brownie import TruhuisAddressRegistry, network


def get_marketplace():
    address_registry = TruhuisAddressRegistry[-1]

    print(
        f"Calling TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    marketplace_addr = address_registry.marketplace()

    print(
        f"Successfully called {address_registry.address}",
        f"The TruhuisMarketplace address is {marketplace_addr}",
    )

    return marketplace_addr


def main():
    get_marketplace()
