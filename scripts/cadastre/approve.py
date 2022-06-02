from brownie import TruhuisCadastre, interface, network

from helper_brownie import CHAINS, get_account, move_blocks


def approve(_token_owner: str, _operator: str, _token_id: int):
    token_owner = get_account(wallet=_token_owner)
    token_id = _token_id
    operator = _operator

    if network.show_active() in CHAINS["local"]:
        move_blocks()

    interface.IERC721(TruhuisCadastre[-1].address).approve(
        operator, token_id, {"from": token_owner}
    )

    if network.show_active() in CHAINS["local"]:
        move_blocks()


def main():
    approve(
        _token_owner=input("NFT Owner (e.g. citizen_nld_1): "),
        _operator=input("Approve to: "),
        _token_id=int(input("tokenId of the NFT Real Estate (e.g. 1): ")),
    )
