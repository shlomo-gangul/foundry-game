// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {GameToken} from "../src/GameToken.sol";

contract GameTokenTest is Test {
    function testGameToken() public {
        GameToken gameToken = new GameToken("GameToken", "GTK");

        // Test initial balance - address(this) receives the initial mint
        uint256 initialBalance = gameToken.balanceOf(address(this));
        assertEq(initialBalance, 1000000 * 10 ** 18);

        // Test transfer
        uint256 amount = 100 * 10 ** 18;
        address recipient = address(0x123);
        gameToken.transfer(recipient, amount);
        uint256 recipientBalance = gameToken.balanceOf(recipient);
        assertEq(recipientBalance, amount);

        // Test approval and transferFrom
        address spender = address(0x456);
        gameToken.approve(spender, amount);

        // Use prank to simulate the spender calling transferFrom
        vm.prank(spender);
        gameToken.transferFrom(address(this), spender, amount);

        uint256 spenderBalance = gameToken.balanceOf(spender);
        assertEq(spenderBalance, amount);
    }
}
