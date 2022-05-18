from brownie import TruhuisAddressRegistry, network


def get_government(_country: str = ""):

    """
    @param _country Country ISO 3166-1 Alpha-3 code (e.g. "NLD" or "DEU") of that Government.
    """

    address_registry = TruhuisAddressRegistry[-1]

    print(
        f"Calling TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    government_addr = address_registry.government(_country)

    print(
        f"Successfully called {address_registry.address}",
        f"The Government address is {government_addr}",
    )

    return government_addr


def main():
    get_government(_country=input("Country of the Government: "))
