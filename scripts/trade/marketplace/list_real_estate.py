from brownie import (
    MockERC20EURT,
    TruhuisCadastre,
    TruhuisMarketplace,
    interface,
    network,
)
from brownie.network.web3 import Web3

from helper_brownie import CHAINS, get_account, move_blocks
from helper_truhuis import CURRENCY_REGISTRY


def list_real_estate(_seller: str, _currency: str, _token_id: int, _price: int, _marketplace=None):
    seller = get_account(wallet=_seller)
    currency_addr = CURRENCY_REGISTRY()[_currency]
    token_id = _token_id
    price = Web3.toWei(_price, "ether")
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]

    interface.IERC721(TruhuisCadastre[-1].address).approve(
        marketplace.address, token_id, {"from": seller}
    )

    tx = marketplace.listRealEstate(currency_addr, token_id, price, {"from": seller})
    tx.wait(1)

    if network.show_active() in CHAINS["local"]:
        move_blocks()


def main():
    list_real_estate(
        _seller=input("Seller (e.g. citizen_usd_3): "),
        _currency=input("Currency (e.g. USDT): "),
        _token_id=int(input("tokenId of the NFT Real Estate (e.g. 6): ")),
        _price=int(input("Price: ")),
        _marketplace=TruhuisMarketplace[-1],
    )
