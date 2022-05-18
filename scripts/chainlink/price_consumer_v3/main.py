from scripts.chainlink.price_consumer_v3.deploy import deploy
from scripts.chainlink.price_consumer_v3.get_decimals import get_decimals
from scripts.chainlink.price_consumer_v3.get_price import get_price
from scripts.chainlink.price_consumer_v3.get_proxy import get_proxy
from scripts.chainlink.price_consumer_v3.set_proxy import set_price_feed_proxy


def main():
    id_ = "0"

    deploy()
    set_price_feed_proxy(id_)
    get_price(id_)
    get_proxy(id_)
    get_decimals(id_)
