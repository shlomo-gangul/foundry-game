// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {GameFactory} from "../src/GameFactory.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GameToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}
}

contract GameFactoryTest is Test {
    GameFactory factory;
    ERC20 token;

    function setUp() external {
        token = new GameToken("gameTk", "GTK");
        factory = new GameFactory(address(token), 4e18, 5);
    }

    function testCreateNewGame() public {
        factory.setNewGame();
        assertEq(factory.gameCount(), 1);
    }

    function testIsGameOver() public {
        factory.setNewGame();
        assert(factory.isGameOver() == false);
    }
}
