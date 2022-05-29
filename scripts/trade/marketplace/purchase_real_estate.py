from brownie import TruhuisMarketplace, interface, network

from helper_brownie import CHAINS, get_account, move_blocks


def purchase_real_estate(_buyer: str, _token_id: int, _marketplace=None):
    buyer = get_account(wallet=_buyer)
    token_id = _token_id
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]

    listing = marketplace.getListing(token_id)

    seller = listing["seller"]
    currency_addr = listing["currency"]
    price = listing["initialPrice"]

    interface.IERC20(currency_addr).approve(marketplace.address, price, {"from": buyer})

    tx = marketplace.purchaseRealEstate(seller, currency_addr, token_id, {"from": buyer})
    tx.wait(1)

    if network.show_active() in CHAINS["local"]:
        move_blocks()


def main():
    purchase_real_estate(
        _buyer=input("Buyer (e.g. citizen_usa_3): "),
        _token_id=int(input("tokenId of the NFT Real Estate (e.g. 5): ")),
    )
