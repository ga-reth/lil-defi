// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;
    
/// @title lil smart wallet
/// @author Gareth Veale
/// @notice a super simple smart wallet implementation
contract LilSmartWallet {

    /// @notice Thrown when withdraw request exceeds balance
    error InsufficientBalance(uint balance, uint withdrawAmount);

    /// @notice The owner of this wallet storing funds
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    /// @notice Fallback receive function
    receive() external payable {}

    /// @notice Withdraws funds from smart wallet to provided address
    /// @param _amount The amount to be withdrawn
    function withdraw(uint _amount) external {
        require(msg.sender == owner, "Access denied!");
        uint bal = address(this).balance;
        if (bal < _amount) {
            revert InsufficientBalance({balance: bal, withdrawAmount: _amount});
        }
        payable(msg.sender).transfer(_amount);
    }

    /// @notice Withdraws all funds from smart wallet
    function withdrawAll() external {
        require(msg.sender == owner, "Access denied!");
         payable(msg.sender).transfer(address(this).balance);
    }

    /// @notice Returns the balance held in this smart wallet
    function getBalance() external view returns (uint) {
        require(msg.sender == owner, "Access denied!");
        return address(this).balance;
    }
 
}
