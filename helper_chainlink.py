from brownie import network

from helper_brownie import get_mock, CHAINS

CHAINLINK = {
    "hardhat": {
        "price_consumer_v3": {
            "0": {
                "pair": "EUR/USD",
                "proxy": get_mock("chainlink", "price_consumer_v3", "0", "proxy")
                if network.show_active() in CHAINS["local"]
                else "0x",
                "hearbeat": 60,  # minutes
                "decimals": 18,  # amount
            }
        },
    },
    "kovan": {
        "price_consumer_v3": {
            "0": {
                "pair": "EUR/USD",
                "proxy": "0x0c15Ab9A0DB086e062194c273CC79f41597Bbf13",
                "hearbeat": 30,  # minutes
                "decimals": 8,
            },
            "1": {
                "pair": "USDT/USD",
                "proxy": "0x2ca5A90D34cA333661083F89D831f757A9A50148",
                "hearbeat": 1440,  # 24 h
                "decimals": 8,
            },
        },
    },
}

PRICE_CONSUMER_V3 = CHAINLINK[f"{network.show_active()}"]["price_consumer_v3"]
