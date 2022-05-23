from brownie import TruhuisAddressRegistry, TruhuisCadastre, network

from helper_brownie import get_account


def update_cadastre(_cadastre_addr: str = ""):
    truhuis = get_account(wallet="truhuis")
    address_registry = TruhuisAddressRegistry[-1]

    cadastre_addr = _cadastre_addr if _cadastre_addr else TruhuisCadastre[-1].address

    print(
        f"Sending transaction to TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    tx = address_registry.updateCadastre(cadastre_addr, {"from": truhuis})
    tx.wait(1)

    print(
        f"Updated successfully new TruhuisCadastre address on {address_registry.address}.\n",
        f"Run the following to read just updated TruhuisCadastre address:\n",
        f"brownie run scripts/address/get_cadastre.py --network {network.show_active()}",
    )


def main():
    update_cadastre(_cadastre_addr=input("Updated TruhuisCadastre address: "))
