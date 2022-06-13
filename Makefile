# Check for smart contract security
slither:; slither ./contracts/cadastre/TruhuisCadastre.sol --solc-remaps '@openzeppelin=${HOME}/.brownie/packages/OpenZeppelin/openzeppelin-contracts@4.5.0 @chainlink=${HOME}/.brownie/packages/smartcontractkit/chainlink-brownie-contracts@0.4.0' --exclude naming-convention,external-function,low-level-calls --buidler-ignore-compile
toolbox:; docker run -it --rm -v $PWD:/src trailofbits/eth-security-toolbox
# Compile smart contracts
compile:; brownie compile
# Run main.py script
run:; brownie run scripts/main.py --network hardhat
run-rinkeby:; brownie run scripts/main.py --network rinkeby
run-kovan:; brownie run scripts/main.py --network kovan
