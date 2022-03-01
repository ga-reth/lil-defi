// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./LilUniswap.sol";

contract LilUniswapTest is DSTest {
    LilUniswap uniswap;

    function setUp() public {
        uniswap = new LilUniswap();
    }

}