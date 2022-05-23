from brownie import TruhuisMarketplace


def buy_house(_buyer, _seller, _currency_addr: str, _token_id: int, _marketplace=None):
    buyer = _buyer
    seller = _seller
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]

    tx = marketplace.buyHouseFrom(seller, _currency_addr, _token_id, {"from": buyer})
    tx.wait(1)
