// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/// @title lil smart wallet
/// @author Gareth Veale
/// @notice A very limited MEV contract to capitalise on arbitrage oppurtunities between uni + sushi swap
contract LilMEVArbitrage {
    // ISwapRouter public immutable swapRouter;
    // todo define sushi swap router

    // constructor (ISwapRouter _swapRouter, address _factory) public {
    //     swapRouter = _swapRouter;
    //     // todo init sushi router
    // }

    function arbitrageViaFlashLoan(
        address token0,
        address token1,
        uint256 amountToken0,
        uint256 amountToken1
    ) external {
        // get pair address
        // require pair address is defined
        // perform swap of tokens
    }

    function uniswapV3FlashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes calldata data
    ) external {
        // get token0 address
        // get token1 address
        // get ERC20 token
        // approve token on sushiSwap
        //
    }
}
