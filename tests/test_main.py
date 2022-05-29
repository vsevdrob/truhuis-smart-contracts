from brownie import chain, network
import pytest

from helper_brownie import CHAINS, get_account
from helper_chainlink import PRICE_CONSUMER_V3
from helper_truhuis import TOKEN_URIs
from scripts.address.register_state_government import register_state_government
from scripts.address.update_auction import update_auction
from scripts.address.update_cadastre import update_cadastre
from scripts.address.update_currency_registry import update_currency_registry
from scripts.address.update_marketplace import update_marketplace
from scripts.cadastre.safe_mint import safe_mint
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
from scripts.state.government.register_citizen import register_citizen
from scripts.trade.marketplace.list_real_estate import list_real_estate
from scripts.trade.marketplace.purchase_real_estate import purchase_real_estate


def test_main():
    if network.show_active() not in CHAINS["local"]:
        pytest.skip("Only for local testing")

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

    add("EURT")
    add("USDT")

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

    cadastre = deploy_truhuis_cadastre(_truhuis=truhuis, _address_registry=address_registry.address)

    update_cadastre(cadastre.address)

    current_token_id = cadastre.totalSupply()
    print(f"Current amount Truhuis NFTs minted: {current_token_id}")

    print("================================================================")
    print("                               OK                               ")
    print("================================================================")
    token_URI = TOKEN_URIs()["1"]  # generate_token_uri(_token_id=upcoming_token_id)
    current_token_id, tx = safe_mint(
        _to=citizen_nld_1, _truhuis=truhuis, _token_URI=token_URI, _country="nld"
    )
    print("================================================================")
    print("                               OK                               ")
    print("================================================================")
    token_URI = TOKEN_URIs()["2"]  # generate_token_uri(_token_id=upcoming_token_id)
    current_token_id, tx = safe_mint(
        _to=citizen_nld_2, _truhuis=truhuis, _token_URI=token_URI, _country="nld"
    )
    print("================================================================")
    print("                               OK                               ")
    print("================================================================")
    token_URI = TOKEN_URIs()["3"]  # generate_token_uri(_token_id=upcoming_token_id)
    current_token_id, tx = safe_mint(
        _to=citizen_nld_3, _truhuis=truhuis, _token_URI=token_URI, _country="nld"
    )

    print("================================================================")
    print("                               OK                               ")
    print("================================================================")
    token_URI = TOKEN_URIs()["4"]  # generate_token_uri(_token_id=upcoming_token_id)
    current_token_id, tx = safe_mint(
        _to=citizen_usa_1, _truhuis=truhuis, _token_URI=token_URI, _country="usa"
    )
    print("================================================================")
    print("                               OK                               ")
    print("================================================================")
    token_URI = TOKEN_URIs()["5"]  # generate_token_uri(_token_id=upcoming_token_id)
    current_token_id, tx = safe_mint(
        _to=citizen_usa_2, _truhuis=truhuis, _token_URI=token_URI, _country="usa"
    )
    print("================================================================")
    print("                               OK                               ")
    print("================================================================")
    token_URI = TOKEN_URIs()["6"]  # generate_token_uri(_token_id=upcoming_token_id)
    current_token_id, tx = safe_mint(
        _to=citizen_usa_3, _truhuis=truhuis, _token_URI=token_URI, _country="usa"
    )

    print(f"\n- Minted Truhuis NFTs successfully!")
    print(f"- New total amount Truhuis NFTs minted: {current_token_id}")

    #
    #                   TRUHUIS MARKETPLACE
    #

    marketplace = deploy_truhuis_marketplace(address_registry.address)

    update_marketplace(marketplace.address, address_registry, truhuis)

    list_real_estate(
        _seller="citizen_nld_1",
        _currency="EURT",
        _token_id=1,
        _price=750000,
    )

    list_real_estate(
        _seller="citizen_nld_2",
        _currency="EURT",
        _token_id=2,
        _price=850000,
    )

    list_real_estate(
        _seller="citizen_nld_3",
        _currency="EURT",
        _token_id=3,
        _price=1000000,
    )

    list_real_estate(
        _seller="citizen_usa_1",
        _currency="USDT",
        _token_id=4,
        _price=180000000,
    )

    list_real_estate(
        _seller="citizen_usa_2",
        _currency="USDT",
        _token_id=5,
        _price=6500000,
    )

    list_real_estate(
        _seller="citizen_usa_3",
        _currency="USDT",
        _token_id=6,
        _price=7500000,
    )

    purchase_real_estate(
        _buyer="citizen_nld_1",
        _token_id=2,
    )

    purchase_real_estate(
        _buyer="citizen_usa_3",
        _token_id=4,
    )

    #
    #                   CHAINLINK KEEPER
    #

    check_upkeep("chainlink_keeper", 2, marketplace)
    check_upkeep("chainlink_keeper", 4, marketplace)

    if network.show_active() in CHAINS["local"]:

        chain.mine(5)
        perform_upkeep("chainlink_keeper", 2, marketplace)

        chain.mine(5)
        perform_upkeep("chainlink_keeper", 4, marketplace)

    print(cadastre.balanceOf(citizen_nld_3), cadastre.balanceOf(citizen_nld_2))
    print(cadastre.balanceOf(citizen_usa_1), cadastre.balanceOf(citizen_usa_3))

    #
    #                   TRUHUIS AUCTION
    #

    auction = deploy_truhuis_auction()

    update_auction(auction.address, address_registry)

    #
    #                   CHAINLINK PRICE CONSUMER V3
    #

    price_consumer_v3 = deploy_price_consumer_v3(
        _pair=PRICE_CONSUMER_V3()["0"]["pair"],
        _proxy=PRICE_CONSUMER_V3()["0"]["proxy"],
        _deployer=truhuis,
    )

    assert auction is not None
