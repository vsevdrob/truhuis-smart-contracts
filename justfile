alias a := anvil
alias b := build
alias i := install
alias cl := call-local
alias dl := deploy-local
alias lc := lint-check
alias lw := lint-write
alias tl := test-local

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

deploy-local:
    #{{source}} && source venv/bin/activate && python3 commands/31337/deploy.py -da development
    {{source}} && forge script --sig "{{function_sig}}" --fork-url http://127.0.0.1:8545 --private-key {{private_key}} --broadcast -vv script/deploy/Deploy.s.sol:Deploy

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
