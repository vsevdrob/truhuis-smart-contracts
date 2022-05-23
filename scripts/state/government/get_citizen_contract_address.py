from brownie import StateGovernment


def get_citizen_contract_address(_citizen_account, _state_government=None):
    state_government = _state_government if _state_government else StateGovernment[-1]

    citizen_contract_addr = state_government.getCitizenContractAddress(_citizen_account)

    print(citizen_contract_addr)

    return citizen_contract_addr
