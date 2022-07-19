# lil-defi

lil-defi is a repro that deconstructs popular defi protocols and dapps to their core, inspired by [lil-web3](https://github.com/m1guelpf/lil-web3) from [m1guel](https://twitter.com/m1guelpf). Developed and tested with DappTools as an exploration into this library as an alternative to hardhat.

## lil-uniswap

> A very simple and limited adaptation of uniswap, built to deconstruct the protcol to it's barebones to understand how it functions

Uniswap/defi maxis will berate me for ignoring fees and tick spacing, since they're core to uniswap, but given the nature of this project, I excluded them for simplicity. The two contracts are intended to divide the logic appropriately, `LilUniswap` acts as the central contract, allowing the creation and deployment of token pools. `LilUniswapPool` represent the liquidity pools for each token pair and contain the logic for interacting with them.

[Contract Source](src/LilUniswap.sol) • [Contract Tests](src/LilUniswap.t.sol)

## lil-smart-wallet

> A super simple smart contract wallet

lil smart wallet is a simple demonstration of how a smart contract can be used as a wallet. The observation here is that we can quite simply check owners of contracts + validate callers of functions.

[Contract Source](src/LilSmartWallet.sol) • [Contract Tests](src/LilSmartWallet.t.sol)

## lil-mev-arbitrage

> A very limited MEV contract to explore how smart contracts can be used to capitalise on arbitrage oppurtunities between exchanges

soonTm

## lil-dex

>

soonTm
