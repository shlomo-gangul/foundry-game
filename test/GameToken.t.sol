// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {GameToken} from "../src/GameToken.sol";

contract GameTokenTest is Test {
    function testGameToken() public {
        GameToken gameToken = new GameToken("GameToken", "GTK");

        // Test initial balance
        uint256 initialBalance = gameToken.balanceOf(msg.sender);
        assert(initialBalance == 0);

        // Test transfer
        uint256 amount = 100;
        gameToken.transfer(msg.sender, amount);
        uint256 newBalance = gameToken.balanceOf(msg.sender);
        assert(newBalance == amount);

        // Test approval and transferFrom
        gameToken.approve(address(this), amount);
        gameToken.transferFrom(msg.sender, address(this), amount);
        uint256 finalBalance = gameToken.balanceOf(address(this));
        assert(finalBalance == amount);
    }
}
