from brownie import StateGovernment


def get_country(_state_government_contract):
    state_government_contract = (
        _state_government_contract if _state_government_contract else StateGovernment[-1]
    )
    country = state_government_contract.getCountry()

    print(country.decode())
