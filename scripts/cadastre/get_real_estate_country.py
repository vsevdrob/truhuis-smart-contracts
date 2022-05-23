from brownie import TruhuisCadastre, interface


def get_real_estate_country(_token_id: int, _cadastre=None):
    cadastre = _cadastre if _cadastre else TruhuisCadastre[-1]
    (transferTaxReceiver, _) = cadastre.royaltyInfo(_token_id, 1)
    country = interface.IStateGovernment(transferTaxReceiver).getCountry()

    print(country.decode())
