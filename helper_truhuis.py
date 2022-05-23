from brownie import config, network
from brownie.convert import to_bytes

from helper_brownie import get_mock

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
            "EURT": get_mock("truhuis", "currency_registry", "EURT"),
            "USDT": get_mock("truhuis", "currency_registry", "USDT"),
            "owner": str(config["networks"][f"{network.show_active()}"]["truhuis"]),
        },
        "cadastre": {
            "contract_URI": "ipfs://",
            "owner": str(config["networks"][f"{network.show_active()}"]["truhuis"]),
        },
        "marketplace": {
            "owner": str(config["networks"][f"{network.show_active()}"]["truhuis"]),
            "commission": 250,  # e.g. 100 (1%); 1000 (10%)
        },
        "state_government": {
            "nld": {
                "country": b"nld",
                "transfer_tax": 200,  # 2% in a specific case
                "cooling_off_period": 0,  # 259200,  # seconds (3 days)
            },
            "usa": {
                "country": b"usa",
                "transfer_tax": 120,  # 1.2% in a specific case
                "cooling_off_period": 0,  # 259200,  # seconds (3 days)
            },
        },
        "citizen": {
            "nld": [
                {  # 0
                    "name": [b"daan", b"de jong"],
                    "date_of_birth": [142100, 21, 4, 2000],
                    "place_of_birth": [b"amsterdam", b"north holland", b"nld"],
                    "account": [config["networks"][network.show_active()]["citizen_nld_1"]],
                    "uri": ["ipfs://", "ipfs://"],
                    "citizenship": [b"nld"],
                },
                {  # 1
                    "name": [b"emma", b"de vries"],
                    "date_of_birth": [115609, 21, 4, 1994],
                    "place_of_birth": [b"utrecht", b"utrecht", b"nld"],
                    "account": [config["networks"][network.show_active()]["citizen_nld_2"]],
                    "uri": ["ipfs://", "ipfs://"],
                    "citizenship": [b"nld"],
                },
                {  # 2
                    "name": [b"saar", b"visser"],
                    "date_of_birth": [212512, 9, 7, 1991],
                    "place_of_birth": [b"rotteram", b"south holland", b"nld"],
                    "account": [config["networks"][network.show_active()]["citizen_nld_3"]],
                    "uri": ["ipfs://", "ipfs://"],
                    "citizenship": [b"nld"],
                },
            ],
            "usa": [
                {  # 0
                    "name": [b"william", b"johnson"],
                    "date_of_birth": [142100, 21, 4, 2000],
                    "place_of_birth": [b"salt lake city", b"utah", b"usa"],
                    "account": [config["networks"][network.show_active()]["citizen_usa_1"]],
                    "uri": ["ipfs://", "ipfs://"],
                    "citizenship": [b"usa"],
                },
                {  # 1
                    "name": [b"emily", b"smith"],
                    "date_of_birth": [115609, 21, 4, 1994],
                    "place_of_birth": [b"albuquerque", b"new mexico", b"usa"],
                    "account": [config["networks"][network.show_active()]["citizen_usa_2"]],
                    "uri": ["ipfs://", "ipfs://"],
                    "citizenship": [b"usa"],
                },
                {  # 2
                    "name": [b"aiden", b"williams"],
                    "date_of_birth": [212512, 9, 7, 1991],
                    "place_of_birth": [b"san antonio", b"texas", b"usa"],
                    "account": [config["networks"][network.show_active()]["citizen_usa_3"]],
                    "uri": ["ipfs://", "ipfs://"],
                    "citizenship": [b"usa"],
                },
            ],
        },
    },
    "kovan": {
        "address_registry": {},
        "auction": {
            "owner": str(config["networks"][f"{network.show_active()}"]["truhuis"]),
            "commission": 250,  # e.g. 100 (1%); 1000 (10%)
        },
        "currency_registry": {
            "EURT": get_mock("truhuis", "currency_registry", "EURT"),
            "USDT": get_mock("truhuis", "currency_registry", "USDT"),
            "owner": str(config["networks"][f"{network.show_active()}"]["truhuis"]),
        },
        "cadastre": {
            "contract_URI": "ipfs://",
            "owner": str(config["networks"][f"{network.show_active()}"]["truhuis"]),
        },
        "marketplace": {
            "owner": str(config["networks"][f"{network.show_active()}"]["truhuis"]),
            "commission": 250,  # e.g. 100 (1%); 1000 (10%)
        },
        "state_government": {
            "nld": {
                "country": b"nld",
                "transfer_tax": 200,  # 2% in a specific case
                "cooling_off_period": 60,  # seconds
            },
            "usa": {
                "country": b"usa",
                "transfer_tax": 120,  # 1.2% in a specific case
                "cooling_off_period": 60,  # seconds
            },
        },
        "citizen": {
            "nld": [
                {  # 0
                    "name": [b"daan", b"de jong"],
                    "date_of_birth": [142100, 21, 4, 2000],
                    "place_of_birth": [b"amsterdam", b"north holland", b"nld"],
                    "account": [config["networks"][network.show_active()]["citizen_nld_1"]],
                    "uri": ["ipfs://", "ipfs://"],
                    "citizenship": [b"nld"],
                },
                {  # 1
                    "name": [b"emma", b"de vries"],
                    "date_of_birth": [115609, 21, 4, 1994],
                    "place_of_birth": [b"utrecht", b"utrecht", b"nld"],
                    "account": [config["networks"][network.show_active()]["citizen_nld_2"]],
                    "uri": ["ipfs://", "ipfs://"],
                    "citizenship": [b"nld"],
                },
                {  # 2
                    "name": [b"saar", b"visser"],
                    "date_of_birth": [212512, 9, 7, 1991],
                    "place_of_birth": [b"rotteram", b"south holland", b"nld"],
                    "account": [config["networks"][network.show_active()]["citizen_nld_3"]],
                    "uri": ["ipfs://", "ipfs://"],
                    "citizenship": [b"nld"],
                },
            ],
            "usa": [
                {  # 0
                    "name": [b"william", b"johnson"],
                    "date_of_birth": [142100, 21, 4, 2000],
                    "place_of_birth": [b"salt lake city", b"utah", b"usa"],
                    "account": [config["networks"][network.show_active()]["citizen_usa_1"]],
                    "uri": ["ipfs://", "ipfs://"],
                    "citizenship": [b"usa"],
                },
                {  # 1
                    "name": [b"emily", b"smith"],
                    "date_of_birth": [115609, 21, 4, 1994],
                    "place_of_birth": [b"albuquerque", b"new mexico", b"usa"],
                    "account": [config["networks"][network.show_active()]["citizen_usa_2"]],
                    "uri": ["ipfs://", "ipfs://"],
                    "citizenship": [b"usa"],
                },
                {  # 2
                    "name": [b"aiden", b"williams"],
                    "date_of_birth": [212512, 9, 7, 1991],
                    "place_of_birth": [b"san antonio", b"texas", b"usa"],
                    "account": [config["networks"][network.show_active()]["citizen_usa_3"]],
                    "uri": ["ipfs://", "ipfs://"],
                    "citizenship": [b"usa"],
                },
            ],
        },
    },
}

AMOUNT_TO_MINT = 6

TOKEN_URIS = {
    "1": "ipfs://QmNgmcv7nswQTU7vXkdR7wajzFfh8Ym8ureemBnU1JbDcg?filename=1.json",
    "2": "ipfs://QmaJa1KhFpVkwtSB5z7i294XoPRJ8f5TzBxhxhH1w5qM4h?filename=2.json",
    "3": "ipfs://QmY1GcSMBCFJRV8LLy2UY8zTBHHi73qri7Cu8eT8DrMy38?filename=3.json",
    "4": "ipfs://QmRDrZGrf1MLsVDk5pim8f8o7DM9Cs2T5jzev7xDMpziSD?filename=4.json",
    "5": "ipfs://QmRBNrmwkFqdGps2xiGFtA6FFUinaA8wgPuTakof2G4vVC?filename=5.json",
    "6": "ipfs://QmeeV4oB6eVVWWyytwNN7Fn5pjLYWAnkFMSRozHTfevBgM?filename=6.json",
}

HOUSES = [
    {  # https://www.funda.nl/koop/rotterdam/appartement-88002795-wilhelminakade-575/
        "name": "Truhuis Real Estate # 1",
        "description": "Truhuis aims to improve the property buying and selling methods with the help of the public Ethereum Blockchain (ERC-721) and smart contracts.",
        "image": "ipfs://bafybeibkf4vhhfx45huzskarbs6ri4madhl6p6scyjrm7zhrah5vgipkee",  # https://www.kadasterdata.nl/kadastrale-kaart#/4.4876844/51.9062167/19/19590249470000/0599010400003466
        "attributes": [
            {
                "location": {
                    "street_name": "Wilhelminakade",
                    "street_number": "575",
                    "addition": "",
                    "postcode": "3072 AP",
                    "city": "Rotterdam",
                    "state": "South Holland",
                    "country": "NLD",
                    "coordinates": {
                        "latitude": "51,90640° N",
                        "longitude": "4,48806° E",
                    },
                }
            },
            {"house_type": "Apartment"},
        ],
    },
    {  # https://www.funda.nl/koop/rotterdam/appartement-88165004-de-monchyplein-97/
        "name": "Truhuis Real Estate # 2",
        "description": "Truhuis aims to improve the property buying and selling methods with the help of the public Ethereum Blockchain (ERC-721) and smart contracts.",
        "image": "ipfs://bafybeibjcvb7hxdtcn3yb7vae4p3n54jppahmfe5sndokx4jq6jfyhshs4",  # https://www.kadasterdata.nl/kadastrale-kaart#/4.4893500/51.9057798/19/19590262970000/0599010400016747
        "attributes": [
            {
                "location": {
                    "street_name": "De Monchyplein",
                    "street_number": "97",
                    "addition": "",
                    "postcode": "3072 MM",
                    "city": "Rotterdam",
                    "state": "South Holland",
                    "country": "NLD",
                    "coordinates": {
                        "latitude": "51,90589° N",
                        "longitude": "4,48945° E",
                    },
                }
            },
            {"house_type": "Apartment"},
        ],
    },
    {  # https://www.funda.nl/koop/amsterdam/appartement-42614036-kloveniersburgwal-61-a/
        "name": "Truhuis Real Estate # 3",
        "description": "Truhuis aims to improve the property buying and selling methods with the help of the public Ethereum Blockchain (ERC-721) and smart contracts.",
        "image": "ipfs://bafybeifg4aaodeqyixhqrcpj6nnonvhyeivrhcc5x6rmvat6exrtu4bovm",  # https://www.kadasterdata.nl/kadastrale-kaart#/4.8983923/52.3701486/19/11460300970000/0363010000955402
        "attributes": [
            {
                "location": {
                    "street_name": "Kloveniersburgwal",
                    "street_number": "61",
                    "addition": "A",
                    "postcode": "1011 JZ",
                    "city": "Amsterdam",
                    "state": "North Holland",
                    "country": "NLD",
                    "coordinates": {
                        "latitude": "52,37017° N",
                        "longitude": "4,89845° E",
                    },
                }
            },
            {"house_type": "Apartment"},
        ],
    },
    {  # https://www.432parkpenthouse.com/
        # https://www.serhant.com/listings/3505610
        "name": "Truhuis Real Estate # 4",
        "description": "Truhuis aims to improve the property buying and selling methods with the help of the public Ethereum Blockchain (ERC-721) and smart contracts.",
        "image": "ipfs://bafybeicp74n7atomu7gy36h2uhrp5y6p5nxre6lh62qxiw6zbgvsfgka74",  # https://maps.usgs.gov/map/
        "attributes": [
            {
                "location": {
                    "street_name": "Park Avenue",
                    "street_number": "432",
                    "addition": "96",
                    "postcode": "10022",
                    "city": "New York",
                    "state": "New York",
                    "country": "USA",
                    "coordinates": {
                        "latitude": "40,76167° N",
                        "longitude": "73,97186° W",
                    },
                }
            },
            {"house_type": "Condo"},
        ],
    },
    {  # https://www.serhant.com/listings/TH10E76
        "name": "Truhuis Real Estate # 5",
        "description": "Truhuis aims to improve the property buying and selling methods with the help of the public Ethereum Blockchain (ERC-721) and smart contracts.",
        "image": "ipfs://bafybeie326rotjvcxmjnitc3ypsqmv6qnasswtl6w7vwltqldmzyj77ala",  # https://maps.usgs.gov/map/
        "attributes": [
            {
                "location": {
                    "street_name": "10 East 76th St.",
                    "street_number": "",
                    "addition": "",
                    "postcode": "10021",
                    "city": "New York",
                    "state": "New York",
                    "country": "USA",
                    "coordinates": {
                        "latitude": "40,77451º N",
                        "longitude": "73,96447º W",
                    },
                },
            },
            {"house_type": "Townhouse"},
        ],
    },
    {  # https://www.serhant.com/listings/3672750
        "name": "Truhuis Real Estate # 6",
        "description": "Truhuis aims to improve the property buying and selling methods with the help of the public Ethereum Blockchain (ERC-721) and smart contracts.",
        "image": "ipfs://bafybeiby3pggpehbufhpsw56ze3pn6gjuinsujqdpn3ijg3rze2aqlmdka",  # https://maps.usgs.gov/map/
        "attributes": [
            {
                "location": {
                    "street_name": "Washington Place",
                    "street_number": "80",
                    "addition": "",
                    "postcode": "10011",
                    "city": "New York",
                    "state": "New York",
                    "country": "USA",
                    "coordinates": {
                        "latitude": "40,73183º N",
                        "longitude": "74,00004º W",
                    },
                },
            },
            {"house_type": "Townhouse"},
        ],
    },
]


ADDRESS_REGISTRY = TRUHUIS[f"{network.show_active()}"]["address_registry"]
AUCTION = TRUHUIS[f"{network.show_active()}"]["auction"]
CITIZEN = TRUHUIS[f"{network.show_active()}"]["citizen"]
CITIZEN_NLD = TRUHUIS[f"{network.show_active()}"]["citizen"]["nld"]
CITIZEN_USA = TRUHUIS[f"{network.show_active()}"]["citizen"]["usa"]
CURRENCY_REGISTRY = TRUHUIS[f"{network.show_active()}"]["currency_registry"]
CADASTRE = TRUHUIS[f"{network.show_active()}"]["cadastre"]
MARKETPLACE = TRUHUIS[f"{network.show_active()}"]["marketplace"]
STATE_GOVERNMENT = TRUHUIS[f"{network.show_active()}"]["state_government"]
