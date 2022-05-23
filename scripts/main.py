from brownie import chain, interface, network
from brownie.network.web3 import Web3

from helper_brownie import CHAINS, get_account
from helper_chainlink import PRICE_CONSUMER_V3
from helper_truhuis import CURRENCY_REGISTRY, TOKEN_URIS
from scripts.address.register_state_government import register_state_government
from scripts.address.update_cadastre import update_cadastre
from scripts.address.update_currency_registry import update_currency_registry
from scripts.address.update_marketplace import update_marketplace
from scripts.cadastre.get_real_estate_country import get_real_estate_country
from scripts.cadastre.get_royalty_info import get_royalty_info
from scripts.cadastre.safe_mint import safe_mint
from scripts.cadastre.utils.clean_metadata_directories import clean_metadata_directories
from scripts.cadastre.utils.generate_token_uri import generate_token_uri
from scripts.chainlink.keeper.check_upkeep import check_upkeep
from scripts.chainlink.keeper.perform_upkeep import perform_upkeep
from scripts.currency.add import add
from scripts.deploy.deploy_price_consumer_v3 import deploy as deploy_price_consumer_v3
from scripts.deploy.deploy_state import deploy as deploy_state
from scripts.deploy.deploy_truhuis_address_registry import (
    deploy as deploy_truhuis_address_registry,
)
from scripts.deploy.deploy_truhuis_auction import deploy as deploy_truhuis_auction
from scripts.deploy.deploy_truhuis_cadastre import deploy as deploy_truhuis_cadastre
from scripts.deploy.deploy_truhuis_currency_registry import (
    deploy as deploy_truhuis_currency_registry,
)
from scripts.deploy.deploy_truhuis_marketplace import (
    deploy as deploy_truhuis_marketplace,
)
from scripts.state.government.get_citizen_contract_address import (
    get_citizen_contract_address,
)
from scripts.state.government.get_country import (
    get_country as get_state_government_country,
)
from scripts.state.government.register_citizen import register_citizen
from scripts.trade.marketplace.are_similar_countries import are_similar_countries
from scripts.trade.marketplace.buy_house import buy_house
from scripts.trade.marketplace.list_house import list_house
from scripts.trade.marketplace.update_marketplace_commission_fraction import (
    update as update_marketplace_commission_fraction,
)


def main():
    if network.show_active() in CHAINS["local"] or network.show_active() in CHAINS["test"]:

        truhuis = get_account(wallet="truhuis")

        state_government_nld_account = get_account(wallet="state_government_nld")
        state_government_usa_account = get_account(wallet="state_government_usa")

        citizen_nld_1 = get_account(wallet="citizen_nld_1")
        citizen_nld_2 = get_account(wallet="citizen_nld_2")
        citizen_nld_3 = get_account(wallet="citizen_nld_3")
        citizen_usa_1 = get_account(wallet="citizen_usa_1")
        citizen_usa_2 = get_account(wallet="citizen_usa_2")
        citizen_usa_3 = get_account(wallet="citizen_usa_3")

        #
        #                   TRUHUIS ADDRESS REGISTRY
        #

        address_registry = deploy_truhuis_address_registry()

        #
        #                   TRUHUIS CURRENCY REGISTRY
        #

        currency_registry = deploy_truhuis_currency_registry()

        update_currency_registry(_currency_registry=currency_registry.address)

        add(CURRENCY_REGISTRY["EURT"])
        add(CURRENCY_REGISTRY["USDT"])

        #
        #                   STATE NLD
        #

        state_government_nld_contract = deploy_state(state_government_nld_account, "nld")
        register_citizen(state_government_nld_account, state_government_nld_contract, "nld", 0)
        register_citizen(state_government_nld_account, state_government_nld_contract, "nld", 1)
        register_citizen(state_government_nld_account, state_government_nld_contract, "nld", 2)

        register_state_government(state_government_nld_contract.address, "nld")

        #
        #                   STATE USA
        #

        state_government_usa_contract = deploy_state(state_government_usa_account, "usa")
        register_citizen(state_government_usa_account, state_government_usa_contract, "usa", 0)
        register_citizen(state_government_usa_account, state_government_usa_contract, "usa", 1)
        register_citizen(state_government_usa_account, state_government_usa_contract, "usa", 2)

        register_state_government(state_government_usa_contract.address, "usa")

        #
        #                   TRUHUIS CADASTRE
        #

        cadastre = deploy_truhuis_cadastre(
            _truhuis=truhuis, _address_registry=address_registry.address
        )

        update_cadastre(cadastre.address)

        clean_metadata_directories()

        current_token_id = cadastre.totalSupply()
        print(f"Current amount Truhuis NFTs minted: {current_token_id}")

        # while current_token_id < AMOUNT_TO_MINT:
        print("================================================================")
        print("                               OK                               ")
        print("================================================================")
        # upcoming_token_id = cadastre.totalSupply() + 1
        token_URI = TOKEN_URIS["1"]  # generate_token_uri(_token_id=upcoming_token_id)
        current_token_id, tx = safe_mint(
            _to=citizen_nld_1, _truhuis=truhuis, _token_URI=token_URI, _country="nld"
        )
        print("================================================================")
        print("                               OK                               ")
        print("================================================================")
        # upcoming_token_id = cadastre.totalSupply() + 1
        token_URI = TOKEN_URIS["2"]  # generate_token_uri(_token_id=upcoming_token_id)
        current_token_id, tx = safe_mint(
            _to=citizen_nld_2, _truhuis=truhuis, _token_URI=token_URI, _country="nld"
        )
        print("================================================================")
        print("                               OK                               ")
        print("================================================================")
        # upcoming_token_id = cadastre.totalSupply() + 1
        token_URI = TOKEN_URIS["3"]  # generate_token_uri(_token_id=upcoming_token_id)
        current_token_id, tx = safe_mint(
            _to=citizen_nld_3, _truhuis=truhuis, _token_URI=token_URI, _country="nld"
        )

        print("================================================================")
        print("                               OK                               ")
        print("================================================================")
        # upcoming_token_id = cadastre.totalSupply() + 1
        token_URI = TOKEN_URIS["4"]  # generate_token_uri(_token_id=upcoming_token_id)
        current_token_id, tx = safe_mint(
            _to=citizen_usa_1, _truhuis=truhuis, _token_URI=token_URI, _country="usa"
        )
        print("================================================================")
        print("                               OK                               ")
        print("================================================================")
        # upcoming_token_id = cadastre.totalSupply() + 1
        token_URI = TOKEN_URIS["5"]  # generate_token_uri(_token_id=upcoming_token_id)
        current_token_id, tx = safe_mint(
            _to=citizen_usa_2, _truhuis=truhuis, _token_URI=token_URI, _country="usa"
        )
        print("================================================================")
        print("                               OK                               ")
        print("================================================================")
        # upcoming_token_id = cadastre.totalSupply() + 1
        token_URI = TOKEN_URIS["6"]  # generate_token_uri(_token_id=upcoming_token_id)
        current_token_id, tx = safe_mint(
            _to=citizen_usa_3, _truhuis=truhuis, _token_URI=token_URI, _country="usa"
        )

        print(f"\n- Minted Truhuis NFTs successfully!")
        print(f"- New total amount Truhuis NFTs minted: {current_token_id}")

        #
        #                   CHAINLINK PRICE CONSUMER V3
        #

        price_consumer_v3 = deploy_price_consumer_v3(
            _pair=PRICE_CONSUMER_V3["0"]["pair"],
            _proxy=PRICE_CONSUMER_V3["0"]["proxy"],
            _deployer=truhuis,
        )

        #
        #                   TRUHUIS AUCTION
        #

        # auction = deploy_truhuis_auction()

        # update_auction(auction.address, address_registry)

        # interface.IERC721(cadastre.address).approve(auction.address, 1, {"from": citizen_nld_1})
        # interface.IERC721(cadastre.address).approve(auction.address, 2, {"from": citizen_nld_2})
        # interface.IERC721(cadastre.address).approve(auction.address, 3, {"from": citizen_nld_3})

        # interface.IERC721(cadastre.address).approve(auction.address, 4, {"from": citizen_usa_1})
        # interface.IERC721(cadastre.address).approve(auction.address, 5, {"from": citizen_usa_2})
        # interface.IERC721(cadastre.address).approve(auction.address, 6, {"from": citizen_usa_3})

        #
        #                   TRUHUIS MARKETPLACE
        #

        marketplace = deploy_truhuis_marketplace(address_registry.address)

        update_marketplace(marketplace.address, address_registry, truhuis)

        # get_citizen_contract_address(citizen_nld_1, state_government_nld_contract)

        # are_similar_countries("0x90f79bf6eb2c4f870365e785982e1f101e93b906", 1, marketplace)

        # get_royalty_info(2, Web3.toWei(250000, "ether"))

        # get_state_government_country(state_government_nld_contract)

        # get_real_estate_country(1)

        interface.IERC721(cadastre.address).approve(marketplace.address, 1, {"from": citizen_nld_1})
        interface.IERC721(cadastre.address).approve(marketplace.address, 2, {"from": citizen_nld_2})
        interface.IERC721(cadastre.address).approve(marketplace.address, 3, {"from": citizen_nld_3})

        interface.IERC721(cadastre.address).approve(marketplace.address, 4, {"from": citizen_usa_1})
        interface.IERC721(cadastre.address).approve(marketplace.address, 5, {"from": citizen_usa_2})
        interface.IERC721(cadastre.address).approve(marketplace.address, 6, {"from": citizen_usa_3})

        list_house(
            _seller=citizen_nld_1,
            _currency_addr=CURRENCY_REGISTRY["EURT"],
            _token_id=1,
            _price=Web3.toWei(750000, "ether"),
            _marketplace=marketplace,
        )

        list_house(
            _seller=citizen_nld_2,
            _currency_addr=CURRENCY_REGISTRY["EURT"],
            _token_id=2,
            _price=Web3.toWei(850000, "ether"),
            _marketplace=marketplace,
        )

        list_house(
            _seller=citizen_nld_3,
            _currency_addr=CURRENCY_REGISTRY["EURT"],
            _token_id=3,
            _price=Web3.toWei(1000000, "ether"),
            _marketplace=marketplace,
        )

        list_house(
            _seller=citizen_usa_1,
            _currency_addr=CURRENCY_REGISTRY["USDT"],
            _token_id=4,
            _price=Web3.toWei(180000000, "ether"),
            _marketplace=marketplace,
        )

        list_house(
            _seller=citizen_usa_2,
            _currency_addr=CURRENCY_REGISTRY["USDT"],
            _token_id=5,
            _price=Web3.toWei(6500000, "ether"),
            _marketplace=marketplace,
        )

        list_house(
            _seller=citizen_usa_3,
            _currency_addr=CURRENCY_REGISTRY["USDT"],
            _token_id=6,
            _price=Web3.toWei(7500000, "ether"),
            _marketplace=marketplace,
        )

        interface.IERC20(CURRENCY_REGISTRY["EURT"]).approve(
            marketplace.address, Web3.toWei(850000, "ether"), {"from": citizen_nld_1}
        )

        interface.IERC20(CURRENCY_REGISTRY["USDT"]).approve(
            marketplace.address, Web3.toWei(180000000, "ether"), {"from": citizen_usa_3}
        )

        buy_house(
            _buyer=citizen_nld_1,
            _seller=citizen_nld_2,
            _currency_addr=CURRENCY_REGISTRY["EURT"],
            _token_id=2,
            _marketplace=marketplace,
        )

        buy_house(
            _buyer=citizen_usa_3,
            _seller=citizen_usa_1,
            _currency_addr=CURRENCY_REGISTRY["USDT"],
            _token_id=4,
            _marketplace=marketplace,
        )

        if network.show_active() in CHAINS["local"]:

            chain.mine(5)
            chainlink_keeper = get_account(wallet="chainlink_keeper")
            check_upkeep(chainlink_keeper, 2, marketplace)
            perform_upkeep(chainlink_keeper, 2, marketplace)

            chain.mine(5)
            chainlink_keeper = get_account(wallet="chainlink_keeper")
            check_upkeep(chainlink_keeper, 4, marketplace)
            perform_upkeep(chainlink_keeper, 4, marketplace)

        print(cadastre.balanceOf(citizen_nld_3), cadastre.balanceOf(citizen_nld_2))
        print(cadastre.balanceOf(citizen_usa_1), cadastre.balanceOf(citizen_usa_3))

        print(marketplace.fetchListedHouses())
