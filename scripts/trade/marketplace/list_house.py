from brownie import TruhuisMarketplace


def list_house(_seller, _currency_addr: str, _token_id: int, _price: int, _marketplace=None):
    seller = _seller
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]

    tx = marketplace.listHouse(_currency_addr, _token_id, _price, {"from": seller})
    tx.wait(1)
