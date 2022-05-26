from brownie import TruhuisAddressRegistry, Government, network

from helper_brownie import get_account


def update_government(_new_addr: str = "", _country: str = ""):

    """
    @notice Call TruhuisAddressRegistry contract to update Government contract address.
    @param _new_addr New Government address of the `_country`.
    @param _country Country ISO 3166-1 Alpha-3 code (e.g. "NLD" or "DEU") of that Government.
    """

    truhuis = get_account(wallet="truhuis")
    address_registry = TruhuisAddressRegistry[-1]

    government = _new_addr if _new_addr else Government[-1].address

    print(
        f"Calling TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    tx = address_registry.updateGovernment(government, _country, {"from": truhuis})
    tx.wait(1)

    print(
        f"Updated successfully new Government address on {address_registry.address}\n",
        f"Run the following to read just updated Government address:\n",
        f"brownie run scripts/address/get_government.py get_government {_country} --network {network.show_active()}",
    )


def main():
    update_government(
        _new_addr=input("New Government address: "),
        _country=input("Country that belongs to the Government: "),
    )
