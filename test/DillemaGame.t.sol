// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {DillemaGame} from "../src/DillemaGame.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Choice} from "../src/variables/variables.sol";

contract DillemaGameTest is Test {
    DillemaGame game; // Declare the variable 'game'
    ERC20 token;
    address player1 = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address player2 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    function setUp() external {
        game = new DillemaGame(token, 4e18, 5);

        console.log(token.totalSupply() / 1e18);

        token.transfer(player1, 2e18);
        token.transfer(player2, 2e18);
    }

    function testCreateNewGame() public view {
        assertEq(game.getGameCount(), 0);
    }

    function testSouldBeAbleToJoinGame() public {
        //create new game
        //join game player1
        game.joinGame(player1);

        //join game player2
        game.withdrawOnJoinGame(player2);
        //assert player1 and player2 are not equal

        console.log(game.player1());
        console.log(game.player2());
        assert(player1 != player2);
        //assert player1 and player2 are not the same address
        assert(player1 != address(0));
        assert(player2 != address(0));
    }

    // function testGameDepositsAreEqual() public {
    //     //create new game
    //     );
    //     //join game player1
    //     // game.joinGamePlayer1(player1);
    //     // //join game player2
    //     // game.joinGamePlayer2(player2);
    //     //deposit player1
    //     // game.depositPlayer1(player1, token, 2e18);
    //     // //deposit player2
    //     // game.depositPlayer2(player2, token, 2e18);
    //     //assert deposit of player1 and player2 not 0
    //     assert(game.player1Deposit() != 0 && game.player2Deposit() != 0);
    //     //assert player1Deposit is equal to player2Deposit
    //     assertEq(game.player1Deposit(), game.player2Deposit());
    //     //assert player1Deposit plus player2Deposit is equal to tokenAmountyer2Deposit is equal to tokenAmount
    //     assertEq(
    //         game.player1Deposit() + game.player2Deposit(),
    //         game.tokenAmount()
    //     );
    // }

    // function testSetGameChoice() public {
    //     //create new game

    //     //join game player1
    //     // game.joinGamePlayer1(player1);
    //     // //join game player2
    //     // game.joinGamePlayer2(player2);
    //     //deposit player1
    //     // game.depositPlayer1(player1, token, 2e18);
    //     // //deposit player2
    //     // game.depositPlayer2(player2, token, 2e18);
    //     //set game choice for player1
    //     game.setPlayer1Choice(player1, Choice.Cooperate);
    //     //set game choice for player2
    //     game.setPlayer2Choice(player2, Choice.Defect);
    //     //assert player1Choice is not equal to player2Choice
    //     assert(game.player1Choice() != game.player2Choice());
    //     //assert player1Choice is equal to 1
    //     assert(game.player1Choice() == Choice.Cooperate);
    //     //assert player2Choice is equal to 2
    //     assert(game.player2Choice() == Choice.Defect);
    // }

    // function testPointsAlocation() public {
    //     //create new game

    //     //join game player1
    //     // game.joinGamePlayer1(player1);
    //     // //join game player2
    //     // game.joinGamePlayer2(player2);
    //     //deposit player1
    //     // game.depositPlayer1(player1, token, 2e18);
    //     // //deposit player2
    //     // game.depositPlayer2(player2, token, 2e18);
    //     //set game choice for player1
    //     game.setPlayer1Choice(player1, Choice.Cooperate);
    //     //set game choice for player2
    //     game.setPlayer2Choice(player2, Choice.Defect);
    //     //start a round
    //     game.roundStart();
    //     //assert player1Points is equal to 0
    //     assertEq(game.player1Points(), 2);
    //     //assert player2Points is equal to 0
    //     assertEq(game.player2Points(), 8);
    // }

    // function testGameWinner() public {
    //     // must be words defect or cooperate from type Choice

    //     //create new game

    //     //join game player1
    //     // game.joinGamePlayer1(player1);
    //     // //join game player2
    //     // game.joinGamePlayer2(player2);
    //     //deposit player1
    //     // game.depositPlayer1(player1, token, 2e18);
    //     // //deposit player2
    //     // game.depositPlayer2(player2, token, 2e18);
    //     //set game choice for player1
    //     game.setPlayer1Choice(player1, Choice.Cooperate);
    //     //set game choice for player2
    //     game.setPlayer2Choice(player2, Choice.Defect);
    //     //start a round
    //     game.roundStart();
    //     //set game choice for player1
    //     game.setPlayer1Choice(player1, Choice.Cooperate);
    //     //set game choice for player2
    //     game.setPlayer2Choice(player2, Choice.Defect);
    //     //start a round
    //     game.roundStart();
    //     //set game choice for player1
    //     game.setPlayer1Choice(player1, Choice.Cooperate);
    //     //set game choice for player2
    //     game.setPlayer2Choice(player2, Choice.Defect);
    //     //start a round
    //     game.roundStart();
    //     //set game choice for player1
    //     game.setPlayer1Choice(player1, Choice.Cooperate);
    //     //set game choice for player2
    //     game.setPlayer2Choice(player2, Choice.Defect);
    //     //start a round
    //     game.roundStart();
    //     //set game choice for player1
    //     game.setPlayer1Choice(player1, Choice.Cooperate);
    //     //set game choice for player2
    //     game.setPlayer2Choice(player2, Choice.Defect);
    //     //start a round
    //     game.roundStart();
    //     //assert game winner is player2
    //     assertEq(game.getWinner(), player2);
    // }
}
