from brownie import TruhuisMarketplace

from scripts.cadastre.approve import approve


def main():
    approve(
        _token_owner=input("NFT owner (e.g. citizen_nld_1): "),
        _operator=TruhuisMarketplace[-1].address,
        _token_id=int(input("tokenId (e.g. 1): ")),
    )
