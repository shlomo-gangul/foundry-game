// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {DillemaGame} from "../src/DillemaGame.sol";
import {GameToken} from "../src/GameToken.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Choice} from "../src/variables/variables.sol";

contract DillemaGameTest is Test {
    DillemaGame game; // Declare the variable 'game'
    GameToken gameToken; // Declare the variable 'gameToken'
    address player1 = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address player2 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    function setUp() external {
        gameToken = new GameToken("GameToken", "GTK");
        game = new DillemaGame(gameToken, 4e18, 5);

        console.log(gameToken.balanceOf(address(this)) / 1e18);
        gameToken.transfer(player1, 2e18);

        gameToken.transfer(player2, 2e18);

        vm.prank(player1);
        gameToken.approve(address(game), 1000e18);
        vm.prank(player2);
        gameToken.approve(address(game), 1000e18);
    }

    // function testGamecountIsAccurate() public view {
    //     assertEq(game.getGameCount(), 0); {{{{needs to be in factory}}}}
    // }

    function testSouldBeAbleToJoinGame() public {
        //create new game
        //join game player1
        vm.prank(player1);
        game.joinGame();

        //join game player2
        vm.prank(player2);
        game.joinGame();
        //assert player1 and player2 are not equal

        address game_Player1 = game.player1();
        address game_Player2 = game.player2();

        console.log(game.player1());
        console.log(game.player2());
        assert(game_Player1 != game_Player2);

        //assert player1 and player2 are not the same address
        assertEq(game_Player1, player1);
        assertEq(game_Player2, player2);
    }

    function testGameDepositsAreEqual() public {
        uint player1balanceBefore = gameToken.balanceOf(player1);
        uint player2balanceBefore = gameToken.balanceOf(player2);
        //create new game
        //join game player1
        vm.prank(player1);
        game.joinGame();
        // //join game player2
        vm.prank(player2);
        game.joinGame();
        //deposit player1
        uint player1balanceAfter = gameToken.balanceOf(player1);
        uint player2balanceAfter = gameToken.balanceOf(player2);

        assert(
            player1balanceBefore - player1balanceAfter ==
                player2balanceBefore - player2balanceAfter
        );
    }

    function testSetGameChoice() public {
        //create new game

        //join game player1
        vm.prank(player1);
        game.joinGame();
        //join game player2
        vm.prank(player2);
        game.joinGame();
        vm.prank(player1);
        game.setPlayerChoice(Choice.Cooperate);
        vm.prank(player2);
        game.setPlayerChoice(Choice.Defect);
        //assert player1Choice is not equal to player2Choice
        assert(game.player1Choice() != game.player2Choice());
        //assert player1Choice is equal to 1
        assert(game.player1Choice() == Choice.Cooperate);
        //assert player2Choice is equal to 2
        assert(game.player2Choice() == Choice.Defect);
    }

    function testPointsAlocation() public {
        //create new game

        //join game player1
        vm.prank(player1);
        game.joinGame();
        //join game player2
        vm.prank(player2);
        game.joinGame();
        //set game choice for player1
        vm.prank(player1);
        game.setPlayerChoice(Choice.Cooperate);
        //set game choice for player2
        vm.prank(player2);
        game.setPlayerChoice(Choice.Defect);
        //start a round
        game.roundStart();
        //assert player1Points is equal to 0
        assertEq(game.player1Points(), 2);
        //assert player2Points is equal to 0
        assertEq(game.player2Points(), 8);
    }

    function testGameWinner() public {
        //join game player1
        vm.prank(player1);
        game.joinGame();
        //join game player2
        vm.prank(player2);
        game.joinGame();
        //set game choice for player1
        vm.prank(player1);
        game.setPlayerChoice(Choice.Cooperate);
        //set game choice for player2
        vm.prank(player2);
        game.setPlayerChoice(Choice.Defect);
        //start a round
        game.roundStart();
        //set game choice for player1
        vm.prank(player1);
        game.setPlayerChoice(Choice.Cooperate);
        //set game choice for player2
        vm.prank(player2);
        game.setPlayerChoice(Choice.Defect);
        //start a round
        game.roundStart();
        //set game choice for player1
        vm.prank(player1);
        game.setPlayerChoice(Choice.Cooperate);
        //set game choice for player2
        vm.prank(player2);
        game.setPlayerChoice(Choice.Defect);
        //start a round
        game.roundStart();
        //set game choice for player1
        vm.prank(player1);
        game.setPlayerChoice(Choice.Cooperate);
        //set game choice for player2
        vm.prank(player2);
        game.setPlayerChoice(Choice.Defect);
        //start a round
        game.roundStart();
        //set game choice for player1
        vm.prank(player1);
        game.setPlayerChoice(Choice.Cooperate);
        //set game choice for player2
        vm.prank(player2);
        game.setPlayerChoice(Choice.Defect);
        //start a round
        game.roundStart();
        //assert game winner is player2
        console.log(game.getWinner());
        assertEq(game.getWinner(), player2);
    }
}
