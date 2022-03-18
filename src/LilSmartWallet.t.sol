// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./LilSmartWallet.sol";

contract LilSmartWalletTest is DSTest {
    LilSmartWallet smartWallet;

    function setUp() public {
        smartWallet = new LilSmartWallet();
    }

    function test_withdraw() public {
        payable(address(smartWallet)).transfer(1 ether);
        uint preBalance = address(this).balance;
        smartWallet.withdraw(1 ether);
        uint postBalance = address(this).balance;
        assertEq(preBalance + 1 ether, postBalance);
    }

    function testFail_withdraw() public {
        payable(address(smartWallet)).transfer(1 ether);
        smartWallet.withdraw(5 ether);
    }    

    function test_withdrawAll() public {
        payable(address(smartWallet)).transfer(5 ether);
        uint preBalance = address(this).balance;
        smartWallet.withdraw(1 ether);
        uint postBalance = address(this).balance;
        assertEq(preBalance + 1 ether, postBalance);

        smartWallet.withdrawAll();
        postBalance = address(this).balance;
        assertEq(preBalance + 5 ether, postBalance);
    }

    function test_getBalance() public {
        payable(address(smartWallet)).transfer(5 ether);
        uint balance = smartWallet.getBalance();
        assertEq(balance, 5 ether);   
    }

    receive() external payable {}
}