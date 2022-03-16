// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "lib/v3-core/contracts/libraries/Position.sol";

/// @title lil uniswap
/// @author Gareth Veale
/// @notice An incredibly simplified adaptation of uniswap
contract LilUniswap { 
    
    address public owner;
    mapping(address => mapping(address => address)) public getPoolAddress;
    struct Parameters {
        address lilUniswap;
        address token0;
        address token1;
    }
    Parameters public params;
    event PoolCreated(address token0, address token1, address pool);

    constructor() {
        owner = msg.sender;
    }

    function createPool(address tokenA, address tokenB) external returns (address pool) {
        require(tokenA != tokenB);
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0));
        require(getPoolAddress[token0][token1] == address(0));
        pool = deploy(token0, token1);
        getPoolAddress[token0][token1] = pool;
        getPoolAddress[token1][token0] = pool;
        emit PoolCreated(token0, token1, pool);
    }

    function deploy(address token0, address token1) internal returns (address pool) {
        params = Parameters({lilUniswap: address(this), token0: token0, token1: token1});
        pool = address(new LilUniswapPool{salt: keccak256(abi.encode(token0, token1))}());
        delete params;
    }

}

contract LilUniswapPool { 

    address public immutable lilUniswap;
    address public immutable token0;
    address public immutable token1;
    mapping(bytes32 => Position.Info) public override positions;

    event Mint(address sender, address recipient, uint128 amount, uint256 amount0, uint256 amount1);
    event Collect(address sender, address recipient, uint256 amount0, uint256 amount1);

    constructor() {
        (lilUniswap, token0, token1) = LilUniswap(msg.sender).params();
    }

    function mint(address recipient, uint128 amount, bytes calldata data) external returns (uint256 amount0, uint256 amount1) {
        require(amount > 0);
        (amount0, amount1) = _modifyPosition(recipient, amount);
        ILilUniSwap(msg.sender).uniswapV3MintCallback(amount0, amount1, data);
        emit Mint(msg.sender, recipient, amount, amount0, amount1);
    }
    function collect(address recipient, uint128 amount0Requested, uint128 amount1Requested) external {
        Position.Info storage position = positions.get(msg.sender);

        amount0 = amount0Requested > position.tokensOwed0 ? position.tokensOwed0 : amount0Requested;
        amount1 = amount1Requested > position.tokensOwed1 ? position.tokensOwed1 : amount1Requested;

        if (amount0 > 0) {
            position.tokensOwed0 -= amount0;
            token0.transfer(recipient, amount0);
        }
        if (amount1 > 0) {
            position.tokensOwed1 -= amount1;
            token1.transfer(recipient, amount1);
        }

        emit Collect(msg.sender, recipient, amount0, amount1);
    }
    
    /// TODO
    function swap(address recipient, int256 amountSpecified, bytes calldata data) external returns (int256 amount0, int256 amount1) {}

    /// TODO
    function _modifyPosition(address owner, uint128 liquidityDelta) private returns (uint256 amount0, uint256 amount1) {}

}

contract ILilUniSwap {

    /// @notice Called to `msg.sender` after minting liquidity to a position from IUniswapV3Pool#mint.
    /// @dev In the implementation you must pay the pool tokens owed for the minted liquidity.
    /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
    /// @param amount0Owed The amount of token0 due to the pool for the minted liquidity
    /// @param amount1Owed The amount of token1 due to the pool for the minted liquidity
    /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#mint call
    function uniswapV3MintCallback(uint256 amount0Owed,uint256 amount1Owed,bytes calldata data) external;
        
    /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
    /// @dev In the implementation you must pay the pool tokens owed for the swap.
    /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
    /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
    /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
    /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
    /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
    function uniswapV3SwapCallback(int256 amount0Delta,int256 amount1Delta,bytes calldata data) external;

}