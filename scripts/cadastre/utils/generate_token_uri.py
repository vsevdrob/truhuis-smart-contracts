from brownie import network

from helper_brownie import CHAINS
from helper_truhuis import HOUSES
from scripts.cadastre.utils.config import PATH, PINATA
from scripts.cadastre.utils.helper import dump_to_json
from scripts.cadastre.utils.pinata import upload_file


def generate_token_uri(_token_id: int = int()):

    """
    @param _country Country ISO-3166 code.
    @notice Upload tokenURI to IPFS through Pinata if enabled.
    """

    token_id = _token_id

    map_path = PATH["maps"] + f"/{token_id}.png"
    metadata = HOUSES[int(token_id - 1)]

    metadata_path = PATH["token_metadata"] + f"/{token_id}.json"
    token_uri_path = PATH["token_uri"] + f"/{token_id}.json"

    token_uri = {}

    # if PINATA["enabled"] and network.show_active() not in CHAINS["local"]:
    print(f"Preparing tokenURI for upload to Pinata -> IPFS...")

    # metadata["image"] = upload_file(map_path)
    dump_to_json(metadata, metadata_path)

    token_uri[str(token_id)] = upload_file(metadata_path)
    dump_to_json(token_uri, token_uri_path)

    # else:

    #    metadata["image"] = f"ipfs://Qb1c2d3xxImageURI/{token_id}.png"
    #    dump_to_json(metadata, metadata_path)

    #    token_uri[str(token_id)] = f"ipfs://Qb1c2d3xxTokenURI/{token_id}.json"
    #    dump_to_json(token_uri, token_uri_path)

    print("tokenURI successfully uploaded to IPFS.")

    return token_uri[str(token_id)]
