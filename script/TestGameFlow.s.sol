// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {GameFactory} from "../src/GameFactory.sol";
import {GameToken} from "../src/GameToken.sol";
import {DillemaGame} from "../src/DillemaGame.sol";
import {Choice} from "../src/variables/variables.sol";

contract TestGameFlow is Script {
    GameFactory gameFactory;
    GameToken gameToken;
    address player1;
    address player2;
    
    // Deployed contract addresses (update these with your actual addresses)
    address constant GAME_FACTORY_ADDRESS = 0xa0a395E98F3E5e78AB3081671C5FA7cA0Be83663;
    address constant GAME_TOKEN_ADDRESS = 0x599984aa0C2f39a022fD78a3ED9dd3bAe494D742;
    
    function setUp() public {
        gameFactory = GameFactory(GAME_FACTORY_ADDRESS);
        gameToken = GameToken(GAME_TOKEN_ADDRESS);
    }
    
    function run() external {
        // Get deployer key
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        player1 = vm.addr(deployerPrivateKey);
        
        // For testing, we'll use the same address as both players
        // In a real scenario, you'd have different private keys
        player2 = player1;
        
        vm.startBroadcast(deployerPrivateKey);
        
        console.log("=== TESTING GAME FLOW ON TESTNET ===");
        console.log("Game Factory:", address(gameFactory));
        console.log("Game Token:", address(gameToken));
        console.log("Player 1:", player1);
        console.log("Player 2:", player2);
        
        // Step 1: Check initial state
        checkInitialState();
        
        // Step 2: Create a new game
        address gameAddress = createNewGame();
        
        // Step 3: Test the game flow
        testGameFlow(gameAddress);
        
        vm.stopBroadcast();
    }
    
    function checkInitialState() internal view {
        console.log("\n=== INITIAL STATE CHECK ===");
        
        uint256 gameCount = gameFactory.getGameCount();
        console.log("Current game count:", gameCount);
        
        uint256 player1Balance = gameToken.balanceOf(player1);
        console.log("Player 1 token balance:", player1Balance);
        
        uint256 player2Balance = gameToken.balanceOf(player2);
        console.log("Player 2 token balance:", player2Balance);
        
        uint256 tokenDecimals = gameToken.decimals();
        console.log("Token decimals:", tokenDecimals);
        
        string memory tokenName = gameToken.name();
        console.log("Token name:", tokenName);
        
        string memory tokenSymbol = gameToken.symbol();
        console.log("Token symbol:", tokenSymbol);
    }
    
    function createNewGame() internal returns (address) {
        console.log("\n=== CREATING NEW GAME ===");
        
        uint256 gameAmount = 2 * 10**18; // 2 tokens total (1 token per player)
        uint32 gameDuration = 5; // 5 rounds
        
        console.log("Creating game with:");
        console.log("- Token amount:", gameAmount);
        console.log("- Game duration (rounds):", gameDuration);
        
        // Create new game
        gameFactory.createNewGame(gameToken, gameAmount, gameDuration);
        
        // Get the newly created game address
        uint256 newGameCount = gameFactory.getGameCount();
        address gameAddress = address(gameFactory.getGameAtIndex(newGameCount - 1));
        
        console.log("New game created at:", gameAddress);
        console.log("Total games now:", newGameCount);
        
        return gameAddress;
    }
    
    function testGameFlow(address gameAddress) internal {
        console.log("\n=== TESTING GAME FLOW ===");
        
        DillemaGame game = DillemaGame(gameAddress);
        
        // Check initial game state
        console.log("Game address:", gameAddress);
        console.log("Game token:", address(game.token()));
        console.log("Game token amount:", game.tokenAmount());
        console.log("Game duration:", game.gameDuration());
        console.log("Initial game over status:", game.isGameOver());
        
        // Check player slots
        console.log("Initial player1:", game.player1());
        console.log("Initial player2:", game.player2());
        
        // Get required amount per player (50% of total)
        uint256 totalAmount = game.tokenAmount();
        uint256 playerAmount = totalAmount / 2;
        
        console.log("Amount needed per player:", playerAmount);
        
        // Check if we have enough tokens
        uint256 ourBalance = gameToken.balanceOf(player1);
        console.log("Our current balance:", ourBalance);
        
        if (ourBalance < totalAmount) {
            console.log("WARNING: Insufficient balance to join as both players");
            console.log("Need:", totalAmount);
            console.log("Have:", ourBalance);
            return;
        }
        
        // Approve tokens for the game contract
        console.log("\n=== APPROVING TOKENS ===");
        gameToken.approve(gameAddress, totalAmount);
        console.log("Approved", totalAmount, "tokens for game contract");
        
        // Player 1 joins game
        console.log("\n=== PLAYER 1 JOINING GAME ===");
        game.joinGame();
        console.log("Player 1 joined successfully");
        console.log("Player1 address:", game.player1());
        console.log("Player2 address:", game.player2());
        
        // For testing purposes, we can't easily simulate a second player
        // In a real scenario, you'd need a second account
        console.log("\nNOTE: In a real test, you would need a second account to join as player 2");
        console.log("Game is now waiting for a second player to join");
        
        // Check game state after player 1 joins
        console.log("\n=== GAME STATE AFTER PLAYER 1 JOINS ===");
        console.log("Player1:", game.player1());
        console.log("Player2:", game.player2());
        console.log("Is game over:", game.isGameOver());
        console.log("Current round count:", game.roundCount());
        console.log("Game count:", game.gameCount());
        
        // Show token balances after joining
        console.log("\n=== TOKEN BALANCES AFTER JOIN ===");
        console.log("Game contract balance:", gameToken.balanceOf(gameAddress));
        console.log("Player balance:", gameToken.balanceOf(player1));
        
        console.log("\n=== TEST COMPLETE ===");
        console.log("Game successfully created and player 1 joined");
        console.log("To complete the test, a second player needs to:");
        console.log("1. Have", playerAmount, "tokens");
        console.log("2. Approve tokens for game contract");
        console.log("3. Call joinGame() function");
        console.log("4. Then both players can commit and reveal choices");
    }
}