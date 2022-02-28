# lil-defi

lil-defi is a repro that deconstructs popular defi protocols and dapps to their core, inspired by [lib-web3](https://github.com/m1guelpf/lil-web3) from [m1guel](https://twitter.com/m1guelpf). Developed and tested with DappTools as an exploration into this library as an alternative to hardhat.

## lil-smart-wallet

> A super simple smart contract wallet

lil smart wallet is a simple demonstration of how a smart contract can be used as a wallet.

The observation here is that we can quite easily check for owners of contracts + validate callers of functions are authorised to do so. 

[Contract Source](src/LilSmartWallet.sol) • [Contract Tests](src/LilSmartWallet.t.sol)

## lil-mev-arbitrage

> A very limited MEV contract to capitalise on arbitrage oppurtunities between uniswap + sushi swap

lil mev arbitrage explores a MEV strategy that extracts value via arbitrage across 2 liquidity pools - uniswap and sushi swap.

soonTm
