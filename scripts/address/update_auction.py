from brownie import TruhuisAddressRegistry, TruhuisAuction, network

from helper_brownie import get_account


def update_auction(_auction: str, _address_registry=None):
    truhuis = get_account(wallet="truhuis")
    address_registry = _address_registry if _address_registry else TruhuisAddressRegistry[-1]

    auction = _auction if _auction else TruhuisAuction[-1].address

    print(
        f"Calling TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    tx = address_registry.updateAuction(auction, {"from": truhuis})
    tx.wait(1)

    print(
        f"Updated successfully new TruhuisAuction address on {address_registry.address}.\n",
        f"Run the following to read just updated TruhuisAuction address:\n",
        f"brownie run scripts/address/get_auction.py --network {network.show_active()}",
    )


def main():
    update_auction(_auction=input("New TruhuisAuction address: "))
