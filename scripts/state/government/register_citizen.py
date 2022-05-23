from helper_truhuis import CITIZEN


def register_citizen(
    _state_government_account, _state_government_contract, _country: str = "", _index: int = int()
):

    """
    @param _state_government_contract State Government contract (ProjectContract brownie object).
    @param _country Country ISO-3166 code (e.g. 'nld' or 'deu').
    @param _index Index in the list in helper_truhuis.py (e.g. 0 or 2)
    """

    tx = _state_government_contract.registerCitizen(
        CITIZEN[_country][_index]["name"],
        CITIZEN[_country][_index]["date_of_birth"],
        CITIZEN[_country][_index]["place_of_birth"],
        CITIZEN[_country][_index]["account"],
        CITIZEN[_country][_index]["uri"],
        CITIZEN[_country][_index]["citizenship"],
        {"from": _state_government_account},
    )
    tx.wait(1)

    # citizen_contract = Citizen.deploy(
    #    CITIZEN[_country][_index]["name"],
    #    CITIZEN[_country][_index]["date_of_birth"],
    #    CITIZEN[_country][_index]["place_of_birth"],
    #    CITIZEN[_country][_index]["account"],
    #    CITIZEN[_country][_index]["uri"],
    #    CITIZEN[_country][_index]["citizenship"],
    #    {"from": _state_government_account},
    # )

    # tx = _state_government_contract.registerCitizen(
    #    CITIZEN[_country][_index]["account"][0],
    #    citizen_contract.address,
    #    {"from": _state_government_account},
    # )
    # tx.wait(1)

    # get_citizen(CITIZEN[_country][_index]["account"][0])
    # print(f"Registered new citizen contract: {citizen_contract.address}")
