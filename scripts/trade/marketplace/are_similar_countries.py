from brownie import TruhuisMarketplace


def are_similar_countries(_account_addr, _token_id: int, _marketplace=None):
    marketplace = _marketplace if _marketplace else TruhuisMarketplace[-1]
    are_similar = marketplace.areSimilarCountries(_account_addr, _token_id)

    print(f"{_account_addr} and {_token_id} tokenId are {are_similar} from similar countries")
