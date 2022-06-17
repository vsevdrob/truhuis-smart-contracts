# Truhuis Smart Contracts

<br/>
<p align="center">
<img src="img/Truhuis_logo.png" width="225" alt="Truhuis logo">
</a>
</p>
<br/>

## Technology Stack & Tools

- [Solidity](https://docs.soliditylang.org/en/latest/index.html) (High-level language for implementing smart contracts)
- [Ethereum](https://ethereum.org/en/) (Decentralized, open-source blockchain with smart contract functionality)
- [Chainlink](https://docs.chain.link/) (Allows securely connect smart contracts with off-chain data and services)
- [OpenZeppelin](https://docs.openzeppelin.com/contracts/4.x/) (A library for secure smart contract development)
- [Brownie](https://eth-brownie.readthedocs.io/en/stable/toctree.html#) (Python development framework for Ethereum)
- [IPFS](https://docs.ipfs.io/) (IPFS is a distributed system for storing and accessing files, websites, applications, and data)
- [Filecoin](https://docs.filecoin.io/) (Filecoin is a peer-to-peer network that stores files, with built-in economic incentives to ensure files are stored reliably over time)
- [Pinata](https://docs.pinata.cloud/) (Cloud-based InterPlanetary File System service provider; no need to run IPFS node by yourself)
- [Hardhat](https://hardhat.org/hardhat-network/) (Local Blockchain environment)
- [Infura](https://docs.infura.io/infura/) (Blockchain API to connect to a Testnet or a Mainnet; no need to run own Blockchain node)
- [Alchemy](https://docs.alchemy.com/alchemy/) (Blockchain API to connect to a Testnet or a Mainnet; no need to run own Blockchain node)

## Prerequisite
Please install or have installed the following:

- [Python](https://python.org/downloads/)
- [NodeJS](https://nodejs.org/en/download/)
- [Yarn](https://classic.yarnpkg.com/lang/en/docs/install/)

## Installation

```bash
# clone the repository
git clone https://github.com/truhuis/truhuis-smart-contracts.git && \
# change current working directory
cd truhuis-smart-contracts && \
# have installed python virtual environment
python3 install virtualenv && \
# create a fresh virtual environment
python3 -m virtualenv venv && \
# source the virtual environment
source venv/bin/activate && \
# install all Python requirements
pip3 install -r requirements.txt && \
# install all Yarn requirements
yarn
```
