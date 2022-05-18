from brownie import TruhuisAddressRegistry, network


def get_auction():
    address_registry = TruhuisAddressRegistry[-1]

    print(
        f"Calling TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    auction_addr = address_registry.auction()

    print(
        f"Successfully called {address_registry.address}",
        f"The TruhuisAuction address is {auction_addr}",
    )

    return auction_addr


def main():
    get_auction()
