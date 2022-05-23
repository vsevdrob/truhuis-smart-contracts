from brownie import Citizen


def get_citizenship(_citizen_contract_addr: str):
    citizen_contract_addr = _citizen_contract_addr if _citizen_contract_addr else Citizen[-1]
    country = citizen_contract_addr.getCitizenship()
