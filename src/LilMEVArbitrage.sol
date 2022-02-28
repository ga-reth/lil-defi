// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "../lib/v3-periphery/contracts/interfaces/ISwapRouter.sol";

/// @title lil smart wallet
/// @author Gareth Veale
/// @notice A very limited MEV contract to capitalise on arbitrage oppurtunities between uni + sushi swap
contract LilMEVArbitrage { 

    ISwapRouter public immutable swapRouter;
    // todo define sushi swap router

    constructor (ISwapRouter _swapRouter, address _factory) public {
        swapRouter = _swapRouter;
        // todo init sushi router
    }

    function arbitrageViaFlashLoan(address token0, address token1, uint amountToken0, uint amountToken1) external {
        // get pair address
        // require pair address is defined
        // perform swap of tokens
    }

    function uniswapV3FlashCallback(uint256 fee0, uint256 fee1, bytes calldata data) external {
        // get token0 address
        // get token1 address

        // get ERC20 token
        // approve token on sushiSwap

        // 
    }

}
