// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "./interfaces/ILilUniSwap.sol";

/// @title lil uniswap
/// @author Gareth Veale
/// @notice An incredibly simplified adaptation of uniswap, do
contract LilUniswap {
    address public owner;
    mapping(address => mapping(address => mapping(uint256 => address)))
        public getPoolAddress;
    struct Parameters {
        address lilUniswap;
        address token0;
        address token1;
        uint256 fee;
    }
    Parameters public params;
    event PoolCreated(
        address token0,
        address token1,
        address pool,
        uint256 fee
    );

    constructor() {
        owner = msg.sender;
    }

    /// @notice Creates an instance of LilUniswapPool for a pair of 2 tokens
    /// @param tokenA The first token of the pool
    /// @param tokenB The second token of the pool
    /// @param fee The fee collected upon every swap in the pool
    function createPool(
        address tokenA,
        address tokenB,
        uint256 fee
    ) external returns (address pool) {
        require(tokenA != tokenB);
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        require(token0 != address(0));
        require(getPoolAddress[token0][token1][fee] == address(0));
        pool = deploy(token0, token1, fee);
        getPoolAddress[token0][token1][fee] = pool;
        // populate mapping in the reverse direction, deliberate choice to avoid the cost of comparing addresses
        getPoolAddress[token1][token0][fee] = pool;
        emit PoolCreated(token0, token1, pool, fee);
    }

    /// @notice Deploys an instance of LilUniswapPool for a pair of 2 tokens
    function deploy(
        address token0,
        address token1,
        uint256 fee
    ) internal returns (address pool) {
        params = Parameters({
            lilUniswap: address(this),
            token0: token0,
            token1: token1,
            fee: fee
        });
        pool = address(
            new LilUniswapPool{
                salt: keccak256(abi.encode(token0, token1, fee))
            }()
        );
        delete params;
    }
}

contract LilUniswapPool {
    struct PositionInfo {
        // the amount of liquidity owned by this position
        uint256 liquidity;
        // the fees owed to the position owner in token0/token1
        uint256 tokensOwed0;
        uint256 tokensOwed1;
    }

    struct ModifyPositionParams {
        // the address that owns the position
        address owner;
        // any change in liquidity
        int256 liquidityDelta;
    }

    address public immutable lilUniswap;
    address public immutable token0;
    address public immutable token1;
    uint256 public immutable fee;
    mapping(address => PositionInfo) public positions;

    event Mint(
        address sender,
        address recipient,
        int256 amount,
        int256 amount0,
        int256 amount1
    );

    event Collect(
        address sender,
        address recipient,
        uint256 amount0,
        uint256 amount1
    );

    constructor() {
        (lilUniswap, token0, token1, fee) = LilUniswap(msg.sender).params();
    }

    /// @notice mint a new position in the pool (LP's)
    function mint(
        address _recipient,
        int256 _amount,
        bytes calldata _data
    ) external returns (int256 amount0, int256 amount1) {
        require(_amount > 0);

        (amount0, amount1) = _modifyPosition(
            ModifyPositionParams({owner: _recipient, liquidityDelta: _amount})
        );

        ILilUniSwap(msg.sender).uniswapV3MintCallback(amount0, amount1, _data);

        emit Mint(msg.sender, _recipient, _amount, amount0, amount1);
    }

    function collect(
        address recipient,
        uint256 amount0Requested,
        uint256 amount1Requested
    ) external returns (uint256 amount0, uint256 amount1) {
        require(positions[msg.sender].liquidity != 0);

        PositionInfo storage position = positions[msg.sender];

        amount0 = amount0Requested > position.tokensOwed0
            ? position.tokensOwed0
            : amount0Requested;
        amount1 = amount1Requested > position.tokensOwed1
            ? position.tokensOwed1
            : amount1Requested;

        // if (amount0 > 0) {
        //     transferOut(token0, recipient, amount0);
        // }
        // if (amount1 > 0) {
        //     position.tokensOwed1 -= amount1;
        //     transferOut(token1, recipient, amount1);
        // }

        emit Collect(msg.sender, recipient, amount0, amount1);
    }

    /// TODO
    function swap(
        address recipient,
        int256 amountSpecified,
        bytes calldata data
    ) external returns (int256 amount0, int256 amount1) {}

    /// TODO - check v2
    function _modifyPosition(ModifyPositionParams memory params)
        private
        returns (int256 amount0, int256 amount1)
    {}
}
