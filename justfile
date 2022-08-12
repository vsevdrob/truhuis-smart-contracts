alias a := anvil
alias b := build
alias i := install
alias cl := call-local
## DEPLOY CONTRACTS (local)
alias dlall := deploy-local-all
alias dlar := deploy-local-addresser
alias dla := deploy-local-appraiser
alias dlb := deploy-local-bank
alias dlc := deploy-local-cadastre
alias dli := deploy-local-inspector
alias dln := deploy-local-notary
alias dlm := deploy-local-municipality
alias dlprd := deploy-local-personal-records-database
alias dlta := deploy-local-tax-administration
alias dlt := deploy-local-trade
## LINT CONTRACTS
alias lc := lint-check
alias lw := lint-write
alias tl := test-local
alias uaall := update-address-all
alias ua := update-address

# Load .env file.
set dotenv-load := true
# Pass justfile recipe args as positional arguments to commands.
set positional-arguments := true

default:
    @just --list

source := "export PATH=$PATH:$HOME/.foundry/bin"

# [DEBUG]: Run anvil local Ethereum development node
anvil *args="":
    {{source}} && anvil {{args}}

# [BUILD]: Build the project's smart contracts.
build:
    {{source}} && forge build

# [CALL]: Perform a call on an account without publishing a transaction.
call-local contract_addr function_sig:
    {{source}} && cast call {{contract_addr}} "{{function_sig}}" --rpc-url http://127.0.0.1:8545

# [CLEAN]: Remove the build artifacts and cache directories.
clean:
    {{source}} && forge clean

# [DEPLOY]: Deploy all smart contracts.
deploy-local-all:
    just deploy-local-addresser && \
    just deploy-local-appraiser && \
    just deploy-local-bank && \
    just deploy-local-cadastre && \
    just deploy-local-inspector && \
    just deploy-local-notary && \
    just deploy-local-municipality && \
    just deploy-local-personal-records-database && \
    just deploy-local-tax-administration && \
    just deploy-local-trade && \
    cp -r ./broadcast/* ../truhuis-addresser-client/contracts/deployments && \
    cp -r ./out/* ../truhuis-addresser-client/contracts/abi

update-address-all:
    just update-address PersonalRecordsDatabase "PERSONAL RECORDS DATABASE" && \
    just update-address TaxAdministration "TAX ADMINISTRATION" && \
    just update-address TruhuisAppraiser "APPRAISER" && \
    just update-address TruhuisBank "BANK" && \
    just update-address TruhuisCadastre "CADASTRE" && \
    just update-address TruhuisInspector "INSPECTOR" && \
    just update-address TruhuisNotary "NOTARY" && \
    just update-address TruhuisTrade "TRADE"

update-address contract id:
    {{source}} && cast send \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --rpc-url http://127.0.0.1:8545/ \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddresser.s.sol/31337/deploy-latest.json` \
    "updateAddress(address,bytes32)" `jq -r ".transactions[0].contractAddress" ./broadcast/Deploy{{contract}}.s.sol/31337/deploy-latest.json` `cast --from-utf8 "{{id}}"`

# ADDRESSER

# [DEPLOY]: Deploy TruhuisAddresser.sol on local network.
deploy-local-addresser:
    {{source}} && forge script \
    script/deploy/DeployTruhuisAddresser.s.sol:DeployTruhuisAddresser \
    --sig "deploy()" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvv

# APPRAISER

# [DEPLOY]: Deploy TruhuisAppraiser.sol on local network.
deploy-local-appraiser:
    {{source}} && forge script \
    --sig "deploy(address)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvv \
    script/deploy/DeployTruhuisAppraiser.s.sol:DeployTruhuisAppraiser \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddresser.s.sol/31337/deploy-latest.json`

# BANK

# [DEPLOY]: Deploy TruhuisBank.sol on local network.
deploy-local-bank:
    {{source}} && forge script \
    --sig "deploy(address)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvv \
    script/deploy/DeployTruhuisBank.s.sol:DeployTruhuisBank \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddresser.s.sol/31337/deploy-latest.json`

# CADASTRE

# [DEPLOY]: Deploy TruhuisCadastre.sol on local network.
deploy-local-cadastre:
    {{source}} && forge script \
    --sig "deploy(address,string)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvv \
    script/deploy/DeployTruhuisCadastre.s.sol:DeployTruhuisCadastre \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddresser.s.sol/31337/deploy-latest.json` \
    "ipfs://"

# INSPECTOR

# [DEPLOY]: Deploy TruhuisInspector.sol on local network.
deploy-local-inspector:
    {{source}} && forge script \
    --sig "deploy(address)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvv \
    script/deploy/DeployTruhuisInspector.s.sol:DeployTruhuisInspector \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddresser.s.sol/31337/deploy-latest.json`

# NOTARY

# [DEPLOY]: Deploy TruhuisNotary.sol on local network.
deploy-local-notary:
    {{source}} && forge script \
    --sig "deploy(address)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvv \
    script/deploy/DeployTruhuisNotary.s.sol:DeployTruhuisNotary \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddresser.s.sol/31337/deploy-latest.json`

# STATE

# [DEPLOY]: Deploy Municipality.sol on local network.
deploy-local-municipality:
    {{source}} && forge script \
    --sig "deploy(bytes4)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_1 \
    --broadcast \
    -vvv \
    script/deploy/DeployMunicipality.s.sol:DeployMunicipality \
    0x30333633

# [DEPLOY]: Deploy PersonalRecordsDatabase.sol on local network.
deploy-local-personal-records-database:
    {{source}} && forge script \
    --sig "deploy(address)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvvv \
    script/deploy/DeployPersonalRecordsDatabase.s.sol:DeployPersonalRecordsDatabase \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddresser.s.sol/31337/deploy-latest.json`

# [DEPLOY] deploy TaxAdministration.sol on local network.
deploy-local-tax-administration:
    {{source}} && forge script \
    --sig "deploy()" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvv \
    script/deploy/DeployTaxAdministration.s.sol:DeployTaxAdministration \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddresser.s.sol/31337/deploy-latest.json`

# TRADE

# [DEPLOY]: Deploy TruhuisTrade.sol on local network.
deploy-local-trade:
    {{source}} && forge script \
    --sig "deploy(address,uint96)" \
    --rpc-url http://127.0.0.1:8545 \
    --private-key $PRIVATE_KEY_ANVIL_0 \
    --broadcast \
    -vvv \
    script/deploy/DeployTruhuisTrade.s.sol:DeployTruhuisTrade \
    `jq -r ".transactions[0].contractAddress" ./broadcast/DeployTruhuisAddresser.s.sol/31337/deploy-latest.json` \
    250

# [HELP]: Run help for a certain command.
help *commands="":
    {{source}} && {{commands}} --help

# [INSTALL]: Install one or multiple dependencies. If no arguments are provided, then existing dependencies will be installed.
install *repositories="":
    {{source}} && forge install {{repositories}}

# [SEND]: Sign and publish a transaction.
send-local private_key contract_addr function_sig:
    {{source}} && cast send --private-key {{private_key}} {{contract_addr}} "{{function_sig}}" --rpc-url http://127.0.0.1:8545

# [TEST]: Run the project's tests.
test-local *v="":
    {{source}} && forge test -vvv{{v}}

# [LINT]: Check for Solidity lintings with Prettier and Solhint.
lint-check:
    yarn solhint src/**/*.sol --config .solhint.json -- ignore-path .solhintignore
    yarn prettier --check src/**/*.sol

# [LINT]: Write Solidity lintings with Prettier.
lint-write:
    yarn prettier --write src/

#verify-address-registry chain_id contract_addr constructor_args:
#    {{source}} && forge verify-contract \
#    --chain-id {{chain_id}} \
#    --num-of-optimatizations 100000 \
#    --constructor-args `cast abi-encode "constructor()" {{constructor_args}}` \
#    --compiler-version v0.8.13+commit.abaa5c0 \
#    --etherscan-api-key ${ETHERSCAN_TOKEN} \
#    {{contract_addr}} \
#    src/core/address/TruhuisAddressRegistry.sol:TruhuisAddressRegistry \
#
#verify-bank chain_id contract_addr constructor_args:
#    {{source}} && forge verify-contract \
#    --chain-id {{chain_id}} \
#    --num-of-optimatizations 100000 \
#    --constructor-args `cast abi-encode "constructor(address)" {{constructor_args}}` \
#    --compiler-version v0.8.13+commit.abaa5c0 \ 
#    {{contract_addr}} \
#    src/core/address/TruhuisAddressRegistry.sol:TruhuisAddressRegistry \
#    ${ETHERSCAN_TOKEN}  
