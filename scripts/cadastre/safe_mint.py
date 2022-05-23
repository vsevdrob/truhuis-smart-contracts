from brownie import TruhuisCadastre

from helper_brownie import get_account


def safe_mint(_to=None, _truhuis=None, _token_URI=None, _country: str = "", _truhuis_cadastre=None):

    """
    @notice Safely new tokenId and transfers it to `_to`
    @param _to The owner of the tokenId.
    @param _truhuis Truhuis account.
    @param _token_URI tokenURI for tokenId token.
    @param _country Property country in the form of ISO-3166 code (e.g. "nld" or "deu").
    @param _truhuis_cadastre Truhuis Cadastre ProjectContract brownie object.
    """

    truhuis = _truhuis if _truhuis else get_account(wallet="truhuis")
    cadastre = _truhuis_cadastre if _truhuis_cadastre else TruhuisCadastre[-1]

    print(f"Minting new Truhuis NFT by assigning new tokenId and tokenURI to it...")

    tx = cadastre.safeMint(_to, _token_URI, bytes(_country, "utf-8"), {"from": truhuis})
    tx.wait(1)

    token_id = cadastre.totalSupply()
    print(f"Minted NFT with the tokenId of {token_id} and tokenURI of {_token_URI}")

    return token_id, tx
