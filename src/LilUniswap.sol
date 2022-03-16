// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

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

    /// TODO
    function swap(address recipient, int256 amountSpecified, bytes calldata data) external returns (int256 amount0, int256 amount1) {}

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
    function _modifyPosition(address owner, uint128 liquidityDelta) private returns (uint256 amount0, uint256 amount1) {
        if (liquidityDelta != 0) {

        }
    } 
}

contract ILilUniSwap {

    /// TODO
    function uniswapV3MintCallback(uint256 amount0, uint256 amount1, bytes calldata data) public {}
    /// TODO
    function uniswapV3SwapCallback() public {}

}