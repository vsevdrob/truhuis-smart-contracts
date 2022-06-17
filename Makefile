default: help

MAIN_PY_PATH 	= ./scripts/main.py
PROJECT_NAME 	= Truhuis
BUILD_DIR 	= ./build
CONTRACTS_DIR 	= ./contracts

help:;
                @echo
                @echo "usage:"
                @echo "  make clean:        Remove $(BUILD_DIR) directory entries."
                @echo "  make compile:      Compiles the contract source files for $(PROJECT_NAME) project and saves the results in the $(BUILD_DIR) folder."
                @echo "  make run:          Use run to execute scripts on hardhat network for contract deployment, to automate common interactions, or for gas profiling."
                @echo "  make test:         Launces pytest and runs the tests for $(PROJECT_NAME) project."
                @echo "  make lint-check    Check if the given *.sol files are formatted."
                @echo

clean:; 	rm -r $(BUILD_DIR)

compile:; 	brownie compile

run:; 		brownie run $(MAIN_PY_PATH) --network hardhat
run-rinkeby:; 	brownie run $(MAIN_PY_PATH) --network rinkeby
run-kovan:; 	brownie run $(MAIN_PY_PATH) --network kovan

#slither:; slither ./contracts/cadastre/TruhuisCadastre.sol --solc-remaps '@openzeppelin=${HOME}/.brownie/packages/OpenZeppelin/openzeppelin-contracts@4.5.0 @chainlink=${HOME}/.brownie/packages/smartcontractkit/chainlink-brownie-contracts@0.4.0' --exclude naming-convention,external-function,low-level-calls --buidler-ignore-compile

test:; 		brownie test

#toolbox:; docker run -it --rm -v $PWD:/src trailofbits/eth-security-toolbox

lint-check:; 	yarn solhint $(CONTRACTS_DIR)/**/*.sol --config .solhint.json --ignore-path .solhintignore
                yarn prettier --check $(CONTRACTS_DIR)/**/*.sol

lint-sol-fix:; 	prettier --write $(CONTRACTS_DIR)/

# Create venv and generate requirements.txt
#init:;          pip3 install virtualenv
#                pip3 -m virtualenv venv
#                source venv/bin/activate
#                pip3 install pipreqs
#                pip3 install pip-tools
#                pipreqs --savepath=requirements.in && pip-compile


# python3 -m virtualenv venv
# source venv/bin/activate
truhuis:;       ./cmd/install.sh

update-requirements:; pip-compile

