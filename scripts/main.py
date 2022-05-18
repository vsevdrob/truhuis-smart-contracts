from brownie import network

from helper_brownie import CHAINS
from helper_truhuis import CITIZEN, GOVERNMENT
from scripts.address.deploy import deploy as deploy_address_registry
from scripts.address.get_auction import get_auction
from scripts.address.get_currency_registry import get_currency_registry
from scripts.address.get_government import get_government
from scripts.address.get_land_registry import get_land_registry
from scripts.address.get_marketplace import get_marketplace
from scripts.address.register_government import register_government
from scripts.address.update_auction import update_auction
from scripts.address.update_currency_registry import update_currency_registry
from scripts.address.update_government import update_government
from scripts.address.update_land_registry import update_land_registry
from scripts.address.update_marketplace import update_marketplace
from scripts.chainlink.price_consumer_v3.deploy import (
    deploy as deploy_price_consumer_v3,
)
from scripts.currency_registry.add import add
from scripts.currency_registry.deploy import deploy as deploy_currency_registry
from scripts.currency_registry.is_allowed import is_allowed
from scripts.land.deploy import deploy as deploy_land_registry
from scripts.land.get_royalty_info import get_royalty_info
from scripts.land.safe_mint import safe_mint
from scripts.state.government import deploy as deploy_government
from scripts.state.government import register_citizen
from scripts.trade.auction.cancel_auction import cancel_auction
from scripts.trade.auction.create_auction import create_auction
from scripts.trade.auction.deploy import deploy as deploy_auction
from scripts.trade.auction.make_bid import make_bid
from scripts.trade.auction.reclaim_erc20 import reclaim_erc20
from scripts.trade.auction.result_auction import result_auction
from scripts.trade.auction.update_auction_commission_fraction import (
    update_auction_commission_fraction,
)
from scripts.trade.auction.update_auction_end_time import update_auction_end_time
from scripts.trade.auction.update_auction_owner import update_auction_owner
from scripts.trade.auction.update_auction_reserve_price import (
    update_auction_reserve_price,
)
from scripts.trade.auction.update_auction_start_time import update_auction_start_time
from scripts.trade.auction.update_bid_withdrawal_lock_time import (
    update_bid_withdrawal_lock_time,
)
from scripts.trade.auction.withdraw_bid import withdraw_bid
from scripts.trade.marketplace.accept_offer import accept_offer
from scripts.trade.marketplace.cancel_listing import cancel_listing
from scripts.trade.marketplace.cancel_offer import cancel_offer
from scripts.trade.marketplace.create_offer import create_offer
from scripts.trade.marketplace.deploy import deploy as deploy_marketplace
from scripts.trade.marketplace.list_house import list_house
from scripts.trade.marketplace.update_listing import update_listing
from scripts.trade.marketplace.update_listing import update_listing
from scripts.trade.marketplace.verify_buyer import verify_buyer
from scripts.trade.marketplace.verify_seller import verify_seller


def main():
    if network.show_active() in CHAINS["local"]:
        deploy_address_registry()

        deploy_auction()
        deploy_currency_registry()
        deploy_land_registry()
        deploy_marketplace()

        get_auction()
        get_currency_registry()
        get_government(_country="NLD")
        get_land_registry()
        get_marketplace()

        deploy_price_consumer_v3()

        update_auction()
        update_currency_registry()
        update_land_registry()
        update_marketplace()

        deploy_government(GOVERNMENT["NLD"])
        register_citizen(CITIZEN["NLD"]["0"])
        register_government(GOVERNMENT["NLD"])

        deploy_government(GOVERNMENT["NLD"])
        register_citizen(CITIZEN["USA"]["0"])
        register_government(GOVERNMENT["USA"])
