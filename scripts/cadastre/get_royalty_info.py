from brownie import TruhuisCadastre


def get_royalty_info(_token_id: int, _sale_price: int, _cadastre=None):
    cadastre = _cadastre if _cadastre else TruhuisCadastre[-1]
    (transfer_tax_receiver, transfer_tax) = cadastre.royaltyInfo(_token_id, _sale_price)

    print(transfer_tax_receiver, transfer_tax)
