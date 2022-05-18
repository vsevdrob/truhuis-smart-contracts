from brownie import TruhuisAddressRegistry, Government, network

from helper_brownie import get_account


def register_government(_government: str = "", _country: str = ""):

    """
    @notice Call TruhuisAddressRegistry contract to register Government contract address.
    @param _government Deployed Government address of the `_country`.
    @param _country Country ISO 3166-1 Alpha-3 code (e.g. "NLD" or "DEU") of that Government.
    """

    truhuis = get_account(wallet="truhuis")
    address_registry = TruhuisAddressRegistry[-1]

    government = _government if _government else Government[-1].address

    print(
        f"Calling TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    tx = address_registry.registerGovernment(government, _country, {"from": truhuis})
    tx.wait(1)

    print(
        "Registered successfully deployed Government address on {address_registry.address}. Transaction Hash: {tx.hash}\n",
        "Run the following to read just registered Government address:\n",
        f"brownie run scripts/address/get_government.py get_government {_country} --network {network.show_active()}",
    )


def main():
    register_government(
        _government=input("Deployed Government address: "),
        _country=input("Country that belongs to the Government: "),
    )
