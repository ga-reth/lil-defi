// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/LilUniswap.sol";

contract LilUniswapTest is DSTest {
    LilUniswap uniswap;

    function setUp() public {
        uniswap = new LilUniswap();
    }
}
