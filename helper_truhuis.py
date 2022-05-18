from brownie import config, network

# if you get error, rerun the `yarn hardhat node` command
# "contract_addr": "0x5FbDB2315678afecb367f032d93F642f64180aa3",
# "contract_addr": "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512",
# "contract_addr": "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0",
# "contract_addr": "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9",
# "contract_addr": "0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9",
# "contract_addr": "0x5FC8d32690cc91D4c39d9d3abcBD16989F875707",
# "contract_addr": "0x0165878A594ca255338adfa4d48449f69242Eb8F"
TRUHUIS = {
    "hardhat": {
        "address_registry": {},
        "auction": {
            "owner": str(config["networks"][f"{network.show_active()}"]["truhuis"]),
            "commission": 250,  # e.g. 100 (1%); 1000 (10%)
        },
        "currency_registry": {
            "owner": str(config["networks"][f"{network.show_active()}"]["truhuis"]),
        },
        "land_registry": {
            "contract_URI": "ipfs://",
            "royalty_receiver": ""
            "owner": str(config["networks"][f"{network.show_active()}"]["truhuis"]),
        },
        "marketplace": {
            "owner": str(config["networks"][f"{network.show_active()}"]["truhuis"]),
            "commission": 250,  # e.g. 100 (1%); 1000 (10%)
        },
        "government_usa": {},
        "government_nld": {},
    }
}

ADDRESS_REGISTRY = TRUHUIS[f"{network.show_active()}"]["address_registry"]
AUCTION = TRUHUIS[f"{network.show_active()}"]["auction"]
CURRENCY_REGISTRY = TRUHUIS[f"{network.show_active()}"]["currency_registry"]
LAND_REGISTRY = TRUHUIS[f"{network.show_active()}"]["land_registry"]
MARKETPLACE = TRUHUIS[f"{network.show_active()}"]["marketplace"]
