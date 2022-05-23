from brownie import TruhuisCurrencyRegistry, network


def is_allowed(_token_addr: str = "") -> bool:
    currency_registry = TruhuisCurrencyRegistry[-1]

    print(
        f"Calling TruhuisCurrencyRegistry contract {currency_registry.address} on network {network.show_active()}"
    )

    is_allowed_ = currency_registry.isAllowed(_token_addr)

    print(
        f"Successfully called {currency_registry.address}",
        f"ERC20 token address {_token_addr} is allowed: {is_allowed_}",
    )

    return is_allowed_


def main():
    is_allowed(_token_addr=input("ERC20 token address: "))
