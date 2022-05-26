from brownie import TruhuisAddressRegistry, TruhuisMarketplace, network

from helper_brownie import get_account


def update_marketplace(_marketplace_addr: str, _address_registry=None, _truhuis=None):
    truhuis = _truhuis if _truhuis else get_account(wallet="truhuis")
    address_registry = _address_registry if _address_registry else TruhuisAddressRegistry[-1]

    marketplace = _marketplace_addr if _marketplace_addr else TruhuisMarketplace[-1].address

    print(
        f"Sending transaction to TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    tx = address_registry.updateMarketplace(marketplace, {"from": truhuis})
    tx.wait(1)

    print(
        f"Updated successfully new TruhuisMarketplace address on {address_registry.address}\n",
        f"Run the following to read just updated TruhuisMarketplace address:\n",
        f"brownie run scripts/address/get_marketplacepy --network {network.show_active()}",
    )


def main():
    update_marketplace(_marketplace_addr=input("Updated TruhuisMarketplace address: "))
