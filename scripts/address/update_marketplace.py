from brownie import TruhuisAddressRegistry, TruhuisMarketplace, network

from helper_brownie import get_account


def update_marketplace(_marketplace: str = ""):
    truhuis = get_account(wallet="truhuis")
    address_registry = TruhuisAddressRegistry[-1]

    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1].address

    print(
        f"Calling TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    tx = address_registry.updateMarketplace(marketplace, {"from": truhuis})
    tx.wait(1)

    print(
        "Updated successfully new TruhuisMarketplace address on {address_registry.address}. Transaction Hash: {tx.hash}\n",
        "Run the following to read just updated TruhuisMarketplace address:\n",
        f"brownie run scripts/address/get_marketplacepy --network {network.show_active()}",
    )


def main():
    update_marketplace(_marketplace=input("New TruhuisMarketplace address: "))
