from brownie import TruhuisAddressRegistry, network


def get_land_registry():
    address_registry = TruhuisAddressRegistry[-1]

    print(
        f"Calling TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    land_registry_addr = address_registry.landRegistry()

    print(
        f"Successfully called {address_registry.address}",
        f"The TruhuisLandRegistry address is {land_registry_addr}",
    )

    return land_registry_addr


def main():
    get_land_registry()
