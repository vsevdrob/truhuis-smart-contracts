from brownie import StateGovernment

from helper_truhuis import STATE_GOVERNMENT


def deploy(_state_government_account, _state_government_country: str = ""):

    """
    @notice Deploy State Government smart contract.
    @param _state_government_account Account (Account brownie object) of the State Government, that becomes the owner of the contract.
    @param _state_government_country ISO 3166-1 alpha-3 country code to which this State Government belongs (e.g. "nld" or "can").
    """

    state_goverment_contract = StateGovernment.deploy(
        STATE_GOVERNMENT()[_state_government_country]["country"],
        STATE_GOVERNMENT()[_state_government_country]["transfer_tax"],
        STATE_GOVERNMENT()[_state_government_country]["cooling_off_period"],
        {"from": _state_government_account},
    )

    return state_goverment_contract
