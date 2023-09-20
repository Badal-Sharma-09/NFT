
#  NFT

Lets create our first NFT👾👾. This smart-contract have two NFTs Basic and Mood.
In Mood NFT you can esaily change 😀😞mood of your NFT.  

## Getting Started
## Requirements

[git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 
You'll know you did it right if you can run git --version and you see a response like git version x.x.x

[foundry](https://getfoundry.sh/)
 You'll know you did it right if you can run forge --version and you see a response like forge 0.2.0 




## Quickstart

```bash
$ git clone https://github.com/HackerBadal/NFT
$ cd NFT
$ forge build
```
    
## Usage
## Deploy

```bash
$ forge script script/DeployBasicNft.s.s.sol  --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

```bash
$ forge script script/DeployMoodNft.s.s.sol  --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```
## Mint a NFT

```bash
$ cast send ${Contract_address} "mintNft()" --private-key ${private-key} --rpc-url ${rpc-url}
```
## Flap a NFT

```bash
$ cast send ${Contract_address} "flipMood()" --private-key ${private-key} --rpc-url ${rpc-url}
```
## Running Tests

To run tests, run the following command

```bash
$ forge test
```


## 🚀 About Me
👾👾I'm a web3 auditor


## 🔗 Thank you!
[![twitter](https://img.shields.io/badge/twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/badal_sharma09)

