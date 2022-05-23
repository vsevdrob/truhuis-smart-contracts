from brownie import TruhuisMarketplace

from helper_brownie import get_account


def update(_new_commission_fraction: int = int()):
    truhuis = get_account(wallet="truhuis")
    marketplace = TruhuisMarketplace[-1]

    tx = marketplace.updateMarketplaceCommissionFraction(
        _new_commission_fraction, {"from": truhuis}
    )
    tx.wait(1)


def main():
    update(
        _new_commission_fraction=int(
            input("New marketplace commission fraction (e.g. 120 (1.2%) or 1000 (10%)): ")
        )
    )
