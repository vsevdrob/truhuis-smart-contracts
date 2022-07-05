alias a := anvil
alias b := build
alias i := install
alias cl := call-local
## DEPLOY CONTRACTS (local)
alias dla := deploy-local-all
alias dltar := deploy-local-truhuis-address-registry
alias dlta := deploy-local-truhuis-appraiser
alias dltb := deploy-local-truhuis-bank
alias dltc := deploy-local-truhuis-cadastre
alias dltcr := deploy-local-truhuis-currency-registry
alias dlti := deploy-local-truhuis-inspector
alias dltn := deploy-local-truhuis-notary
alias dlm := deploy-local-municipality
alias dlprd := deploy-local-personal-records-database
alias dltadmin := deploy-local-tax-administration
alias dltt := deploy-local-truhuis-trade
## LINT CONTRACTS
alias lc := lint-check
alias lw := lint-write
alias tl := test-local

# load .env file
set dotenv-load := true
# pass justfile recipe args as positional arguments to commands
set positional-arguments := true

source := "export PATH=$PATH:$HOME/.foundry/bin"

anvil:
    {{source}} && anvil

build:
    {{source}} && forge build

call-local contract_addr function_sig:
    # $ cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "totalSupply()(uint256)" --rpc-url http://127.0.0.1:8545 
    {{source}} && cast call {{contract_addr}} "{{function_sig}}" --rpc-url http://127.0.0.1:8545

clean:
    {{source}} && forge clean

deploy-local-all:
    just deploy-local-truhuis-address-registry
    just deploy-local-truhuis-appraiser
    just deploy-local-truhuis-bank
    just deploy-local-truhuis-cadastre
    just deploy-local-truhuis-currency-registry
    just deploy-local-truhuis-inspector
    just deploy-local-truhuis-notary
    just deploy-local-municipality
    just deploy-local-personal-records-database
    just deploy-local-tax-administration
    just deploy-local-truhuis-trade

# ADDRESS

deploy-local-truhuis-address-registry:
    {{source}} && forge script \
    script/deploy/DeployTruhuisAddressRegistry.s.sol:DeployTruhuisAddressRegistry \
    --sig "deploy()" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvvv

# APPRAISER

deploy-local-truhuis-appraiser:
    {{source}} && forge script \
    --sig "deploy(address)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvvv \
    script/deploy/DeployTruhuisAppraiser.s.sol:DeployTruhuisAppraiser \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddressRegistry.s.sol/31337/deploy-latest.json`

# BANK

deploy-local-truhuis-bank:
    {{source}} && forge script \
    --sig "deploy(address)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvvv \
    script/deploy/DeployTruhuisBank.s.sol:DeployTruhuisBank \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddressRegistry.s.sol/31337/deploy-latest.json`

# CADASTRE

deploy-local-truhuis-cadastre:
    {{source}} && forge script \
    --sig "deploy(address,string)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvvv \
    script/deploy/DeployTruhuisCadastre.s.sol:DeployTruhuisCadastre \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddressRegistry.s.sol/31337/deploy-latest.json` \
    "ipfs://"
    
# CURRENCY

deploy-local-truhuis-currency-registry:
    {{source}} && forge script \
    script/deploy/DeployTruhuisCurrencyRegistry.s.sol:DeployTruhuisCurrencyRegistry \
    --sig "deploy()" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvvv

# INSPECTOR

deploy-local-truhuis-inspector:
    {{source}} && forge script \
    --sig "deploy(address)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvvv \
    script/deploy/DeployTruhuisInspector.s.sol:DeployTruhuisInspector \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddressRegistry.s.sol/31337/deploy-latest.json`

# NOTARY

deploy-local-truhuis-notary:
    {{source}} && forge script \
    --sig "deploy(address)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvvv \
    script/deploy/DeployTruhuisNotary.s.sol:DeployTruhuisNotary \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddressRegistry.s.sol/31337/deploy-latest.json`

# STATE

deploy-local-municipality:
    {{source}} && forge script \
    --sig "deploy(bytes4)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_1 \
    --broadcast \
    -vvvv \
    script/deploy/DeployMunicipality.s.sol:DeployMunicipality \
    0x30333633

deploy-local-personal-records-database:
    {{source}} && forge script \
    --sig "deploy(address)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvvv \
    script/deploy/DeployPersonalRecordsDatabase.s.sol:DeployPersonalRecordsDatabase \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddressRegistry.s.sol/31337/deploy-latest.json`

deploy-local-tax-administration:
    {{source}} && forge script \
    script/deploy/DeployTaxAdministration.s.sol:DeployTaxAdministration \
    --sig "deploy()" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvvv

# TRADE

deploy-local-truhuis-trade:
    {{source}} && forge script \
    --sig "deploy(address,uint96)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvvv \
    script/deploy/DeployTruhuisTrade.s.sol:DeployTruhuisTrade \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddressRegistry.s.sol/31337/deploy-latest.json` \
    250

install repository:
    # $ forge install Openzeppelin/openzeppelin-contracts --no-commit
    {{source}} && forge install {{repository}}

send-local private_key contract_addr function_sig:
    # $ cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "transfer(address,uint256)" --rpc-url http://127.0.0.1:8545 
    {{source}} && cast send --private-key {{private_key}} {{contract_addr}} "{{function_sig}}" --rpc-url http://127.0.0.1:8545

test-local:
    {{source}} && forge test -vvvv

lint-check:
    yarn solhint src/**/*.sol --config .solhint.json -- ignore-path .solhintignore
    yarn prettier --check src/**/*.sol

lint-write:
    yarn prettier --write src/

#verify-truhuis-address-registry chain_id contract_addr constructor_args:
#    {{source}} && forge verify-contract \
#    --chain-id {{chain_id}} \
#    --num-of-optimatizations 100000 \
#    --constructor-args `cast abi-encode "constructor()" {{constructor_args}}` \
#    --compiler-version v0.8.13+commit.abaa5c0 \
#    --etherscan-api-key ${ETHERSCAN_TOKEN} \
#    {{contract_addr}} \
#    src/core/address/TruhuisAddressRegistry.sol:TruhuisAddressRegistry \
#
#verify-truhuis-bank chain_id contract_addr constructor_args:
#    {{source}} && forge verify-contract \
#    --chain-id {{chain_id}} \
#    --num-of-optimatizations 100000 \
#    --constructor-args `cast abi-encode "constructor(address)" {{constructor_args}}` \
#    --compiler-version v0.8.13+commit.abaa5c0 \ 
#    {{contract_addr}} \
#    src/core/address/TruhuisAddressRegistry.sol:TruhuisAddressRegistry \
#    ${ETHERSCAN_TOKEN}  
