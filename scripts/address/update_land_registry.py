from brownie import TruhuisAddressRegistry, TruhuisLandRegistry, network

from helper_brownie import get_account


def update_land_registry(_land_registry: str = ""):
    truhuis = get_account(wallet="truhuis")
    address_registry = TruhuisAddressRegistry[-1]

    land_registry = _land_registry if _land_registry else TruhuisLandRegistry[-1].address

    print(
        f"Calling TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    tx = address_registry.updateLandRegistry(land_registry, {"from": truhuis})
    tx.wait(1)

    print(
        "Updated successfully new TruhuisLandRegistry address on {address_registry.address}. Transaction Hash: {tx.hash}\n",
        "Run the following to read just updated TruhuisLandRegistry address:\n",
        f"brownie run scripts/address/get_land_registry.py --network {network.show_active()}",
    )


def main():
    update_land_registry(_land_registry=input("New TruhuisLandRegistry address: "))
