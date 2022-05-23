import os

from brownie import network

from helper_brownie import CHAINS

PATH: dict[str, str] = {
    "maps": "./scripts/cadastre/maps",
    "token_metadata": f"./scripts/cadastre/metadata/{network.show_active()}/token_metadata",
    "token_uri": f"./scripts/cadastre/metadata/{network.show_active()}/token_uri",
    "contract_uri": f"./scripts/cadastre/metadata/{network.show_active()}/contract_uri",
}

PINATA = {
    "enabled": True,
    "api_key": str(os.getenv(f"PINATA_API_KEY_MAIN"))
    if network.show_active() in CHAINS["main"]
    else str(os.getenv("PINATA_API_KEY_TEST")),
    "api_secret": str(os.getenv(f"PINATA_API_SECRET_MAIN"))
    if network.show_active() in CHAINS["main"]
    else str(os.getenv("PINATA_API_SECRET_TEST")),
}
