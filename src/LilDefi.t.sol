// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./LilDefi.sol";

contract LilDefiTest is DSTest {
    LilDefi defi;

    function setUp() public {
        defi = new LilDefi();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
