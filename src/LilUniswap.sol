// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;
    
/// @title lil uniswap
/// @author Gareth Veale
/// @notice An incredibly simplified adaptation of uniswap
contract LilUniswap { 
    
    address public owner;
    mapping(address => mapping(address => mapping(uint24 => address))) public getPoolAddress;
    struct Parameters {
        address lilUniswap;
        address token0;
        address token1;
        uint24 fee;
    }
    Parameters public params;

    constructor() {
        owner = msg.sender;
    }

    // factory + pool deployer
    function createPool() external returns (address pool) {}

    function deploy(address token0, address token1, uint24 fee) internal returns (address pool) {
        params = Parameters({lilUniswap: address(this), token0: token0, token1: token1, fee: fee});
        pool = address(new LilUniswapPool{salt: keccak256(abi.encode(token0, token1, fee))}());
        delete params;
    }

    function setOwner() external {}
    
    // swap router
    function getPool() private view returns (address pool) {}

    function uniswapV3SwapCallback() external {}

    /// swaps amountIn of one token for as much as possible of another token
    function swapExactInput() external returns (uint256 amountOut) {}

    /// swaps as little as possible of one token for amountOut of another token
    function swapExactOuput() external returns (uint256 amountIn) {}

}

contract LilUniswapPool { 

    address public immutable lilUniswap;
    address public immutable token0;
    address public immutable token1;
    uint24 public immutable fee;
    bool private unlocked = true;
    // uint128 public immutable maxLiquidityPerTick;

    modifier lock() {
        require(unlocked==true, 'locked');
        unlocked = false;
        _;
        unlocked = true;
    }

    constructor() {
        (lilUniswap, token0, token1, fee) = LilUniswap(msg.sender).params();
    }

    function initialize() external {}
    function balance0() private view returns (uint256) {}
    function balance1() private view returns (uint256) {}
    function mint() external lock returns (uint256 amount0, uint256 amount1) {}
    function collect() external lock returns (uint128 amount0, uint128 amount1) {}
    function burn() external lock returns (uint256 amount0, uint256 amount1) {}
    function swap() external returns (int256 amount0, int256 amount1) {}
    function flash() external lock {}

}




// uniswap is a an AMM - automated market maker
    // achieves this by creating pools, containing token pairs

////  CORE ////

    // UniswapV3Pool - contract that defines the pools
        // liquidity pools that can be used to swap tokens
        // a pool is defined by 2 tokens + a fee
        // 2 tokens can have >1 pool, distinguished only be fee

    // UniswapV3PoolDeployer - logic to deploy pool contract instance

    // UniswapV3Factory - defines logic for deploying pools + manages ownership/control over pool protocol fees


//// PERIPHERY ////
    
    // SwapRouter - defines logic for executing swaps against uniswap v3
        // supports basic requirements of a front-end offering trading

    // NonfungiblePositionManager - defines logic that can wrap uniswap v3 positions in an ERC721 token

    // NonfungibleTokenPositionDescriptor - 

