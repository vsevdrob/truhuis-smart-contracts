from brownie import TruhuisMarketplace, network

from helper_brownie import CHAINS, get_account, move_blocks


def cancel_listing(_seller: str, _token_id: int, _marketplace=None):
    seller = get_account(wallet=_seller)
    token_id = _token_id
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]

    tx = marketplace.cancelListing(token_id, {"from": seller})
    tx.wait(1)

    if network.show_active() in CHAINS["local"]:
        move_blocks()


def main():
    cancel_listing(
        _seller=input("Seller (e.g. citizen_usa_3): "),
        _token_id=int(input("tokenId of the NFT Real Estate (e.g. 4): ")),
    )
