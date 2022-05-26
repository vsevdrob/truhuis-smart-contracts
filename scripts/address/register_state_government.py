from brownie import StateGovernment, TruhuisAddressRegistry, network

from helper_brownie import get_account


def register_state_government(_state_government_contract_addr: str = "", _country: str = ""):

    """
    @notice Call TruhuisAddressRegistry contract to register Government contract address.
    @param _government Deployed Government address of the `_country`.
    @param _country Country ISO 3166-1 Alpha-3 code (e.g. "NLD" or "DEU") of that Government.
    """

    truhuis = get_account(wallet="truhuis")
    address_registry = TruhuisAddressRegistry[-1]

    state_government_contract_addr = (
        _state_government_contract_addr
        if _state_government_contract_addr
        else StateGovernment[-1].address
    )

    print(
        f"Calling TruhuisAddressRegistry contract {address_registry.address} on network {network.show_active()}"
    )

    tx = address_registry.registerStateGovernment(
        state_government_contract_addr, _country.encode("utf-8").hex(), {"from": truhuis}
    )
    tx.wait(1)

    print(
        f"Registered successfully deployed Government address on {address_registry.address}\n",
        f"Run the following to read just registered Government address:\n",
        f"brownie run scripts/address/get_government.py get_government {_country} --network {network.show_active()}",
    )


def main():
    register_state_government(
        _state_government_contract_addr=input("State Government contract address: "),
        _country=input("Country that is associated with the State Government: "),
    )
