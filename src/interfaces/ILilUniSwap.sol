// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

interface ILilUniSwap {
    /// @notice Returns the current owner of the contract
    /// @return The address of the contract owner
    function owner() external view returns (address);

    /// @notice Called to `msg.sender` after minting liquidity to a position from LilUniswapPool#mint.
    /// @dev In the implementation you must pay the pool tokens owed for the minted liquidity.
    /// The caller of this method must be checked to be a LilUniswapPool.
    /// @param amount0 The amount of token0 due to the pool for the minted liquidity
    /// @param amount1 The amount of token1 due to the pool for the minted liquidity
    /// @param data Any data passed through by the caller via the #mint call
    function uniswapV3MintCallback(
        int256 amount0,
        int256 amount1,
        bytes calldata data
    ) external;

    /// @notice Called to `msg.sender` after executing a swap via LilUniswapPool#swap.
    /// @dev In the implementation you must pay the pool tokens owed for the swap.
    /// The caller of this method must be checked to be a LilUniswapPool.
    /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
    /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
    /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
    /// @param data Any data passed through by the caller via the #swap call
    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external;
}
