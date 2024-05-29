// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {DillemaGame} from "../src/DillemaGame.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GameToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}
}

contract DillemaGameTest is Test {
    DillemaGame game; // Declare the variable 'game'\
    ERC20 token;

    function testCreateNewGame() public {
        token = new GameToken("gameTk", "GTK");
        game = new DillemaGame(token, 4e18, 5);
        game.createNewGame(token);
        assertEq(game.getGameCount(), 1);
    }

    function testSouldBeAbleToJoinGame() public {
        address player1 = 0xc0ffee254729296a45a3885639AC7E10F9d54979;
        address player2 = 0x999999cf1046e68e36E1aA2E0E07105eDDD1f08E;
        token = new GameToken("gameTk", "GTK");
        game = new DillemaGame(token, 4e18, 5);
        //create new game
        game.createNewGame(token);
        //join game player1
        game.joinGamePlayer1(player1);
        //join game player2
        game.joinGamePlayer2(player2);
        //assert player1 and player2 are not equal
        assert(player1 != player2);
        //assert player1 and player2 are not the same address
        assert(player1 != address(0));
        assert(player2 != address(0));
    }

    function testGameDepositsAreEqual() public {
        address player1 = 0xc0ffee254729296a45a3885639AC7E10F9d54979;
        address player2 = 0x999999cf1046e68e36E1aA2E0E07105eDDD1f08E;
        token = new GameToken("gameTk", "GTK");
        game = new DillemaGame(token, 4e18, 5);

        //create new game
        game.createNewGame(token);
        //join game player1
        game.joinGamePlayer1(player1);
        //join game player2
        game.joinGamePlayer2(player2);
        //deposit player1
        game.depositPlayer1(player1, token, 2e18);
        //deposit player2
        game.depositPlayer2(player2, token, 2e18);
        //assert deposit of player1 and player2 not 0
        assert(game.player1Deposit() != 0 && game.player2Deposit() != 0);
        //assert player1Deposit is equal to player2Deposit
        assertEq(game.player1Deposit(), game.player2Deposit());
        //assert player1Deposit plus player2Deposit is equal to tokenAmountyer2Deposit is equal to tokenAmount
        assertEq(
            game.player1Deposit() + game.player2Deposit(),
            game.tokenAmount()
        );
    }
}