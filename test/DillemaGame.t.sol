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

    function testShouldBeAbleToJoinGame() public {
        // Join game player1
        vm.prank(player1);
        game.joinGame();

        // Join game player2
        vm.prank(player2);
        game.joinGame();

        // Check if both players have joined
        assertEq(game.player1(), player1);
        assertEq(game.player2(), player2);
        vm.prank(player1);
        game.endGame();
    }

    function testCommitAndRevealChoices() public {
        // Join game player1 and player2
        vm.prank(player1);
        game.joinGame();
        vm.prank(player2);
        game.joinGame();

        // Commit choices
        bytes32 player1Commitment = keccak256(
            abi.encodePacked(Choice.Cooperate, uint256(123))
        );
        bytes32 player2Commitment = keccak256(
            abi.encodePacked(Choice.Defect, uint256(456))
        );

        vm.prank(player1);
        game.commitChoice(player1Commitment);
        vm.prank(player2);
        game.commitChoice(player2Commitment);

        // Reveal choices
        vm.prank(player1);
        game.revealChoice(Choice.Cooperate, 123);
        vm.prank(player2);
        game.revealChoice(Choice.Defect, 456);

        console.log("Player1 Choice:", uint(game.player1Choice()));
        console.log("Player2 Choice:", uint(game.player2Choice()));
        // Check if choices are revealed correctly
        (Choice player1Choice, Choice player2Choice) = game.getRoundChoices();
        assertEq(uint(player1Choice), uint(Choice.Cooperate));
        assertEq(uint(player2Choice), uint(Choice.Defect));
        vm.prank(player1);
        game.endGame();
    }

    function testProcessRoundOutcome() public {
        // Join game player1 and player2
        vm.prank(player1);
        game.joinGame();
        vm.prank(player2);
        game.joinGame();

        // Commit and reveal choices for multiple rounds
        for (uint i = 0; i <= game.gameDuration(); i++) {
            bytes32 player1Commitment = keccak256(
                abi.encodePacked(Choice.Cooperate, uint256(123 + i))
            );
            bytes32 player2Commitment = keccak256(
                abi.encodePacked(Choice.Defect, uint256(456 + i))
            );

            vm.prank(player1);
            game.commitChoice(player1Commitment);
            vm.prank(player2);
            game.commitChoice(player2Commitment);

            vm.prank(player1);
            game.revealChoice(Choice.Cooperate, 123 + i);
            vm.prank(player2);
            game.revealChoice(Choice.Defect, 456 + i);

            console.log("Round:", i);
            console.log("Player1 Choice:", uint(game.player1Choice()));
            console.log("Player2 Choice:", uint(game.player2Choice()));
            console.log("Player1 Points:", game.player1Points());
            console.log("Player2 Points:", game.player2Points());
        }
        vm.prank(player1);
        game.endGame();
        // Check if the game is over and the points are updated correctly
        assertTrue(game.getIsGameOver());
        assertEq(game.player1Points(), 10); // 5 rounds * 2 points per round
        assertEq(game.player2Points(), 40); // 5 rounds * 8 points per round
    }
}
