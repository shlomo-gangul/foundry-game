// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {GameFactory} from "../src/GameFactory.sol";
import {GameToken} from "../src/GameToken.sol";
import {DillemaGame} from "../src/DillemaGame.sol";
import {Choice} from "../src/variables/variables.sol";

contract TestFullGameFlow is Script {
    GameFactory gameFactory;
    GameToken gameToken;
    
    // Deployed contract addresses (correct addresses)
    address constant GAME_FACTORY_ADDRESS = 0xbE02FFD23eA3a53f1e77e8CC06bE9dA2411fE110;
    address constant GAME_TOKEN_ADDRESS = 0x56cD73a04A557325363B278e49B73AC5FdF8dd80;
    
    function setUp() public {
        gameFactory = GameFactory(GAME_FACTORY_ADDRESS);
        gameToken = GameToken(GAME_TOKEN_ADDRESS);
    }
    
    function run() external {
        vm.startBroadcast();
        address deployer = msg.sender;
        
        console.log("=== FULL GAME FLOW TEST ===");
        console.log("Deployer address:", deployer);
        console.log("Deployer balance:", gameToken.balanceOf(deployer));
        
        // Create a new game
        address gameAddress = createGame();
        
        // Test game interactions
        testGameInteractions(gameAddress, deployer);
        
        vm.stopBroadcast();
        
        // Show final API testing instructions
        showAPITestingInstructions(gameAddress);
    }
    
    function createGame() internal returns (address) {
        console.log("\n=== CREATING GAME ===");
        
        uint256 gameAmount = 1 * 10**18; // 1 token total
        uint32 gameDuration = 3; // 3 rounds
        
        uint256 initialGameCount = gameFactory.getGameCount();
        console.log("Games before creation:", initialGameCount);
        
        gameFactory.createNewGame(gameToken, gameAmount, gameDuration);
        
        uint256 newGameCount = gameFactory.getGameCount();
        address gameAddress = address(gameFactory.getGameAtIndex(newGameCount - 1));
        
        console.log("Game created at:", gameAddress);
        console.log("Total games:", newGameCount);
        
        return gameAddress;
    }
    
    function testGameInteractions(address gameAddress, address player) internal {
        console.log("\n=== TESTING GAME INTERACTIONS ===");
        
        DillemaGame game = DillemaGame(gameAddress);
        
        // Check game details
        console.log("Game token amount:", game.tokenAmount());
        console.log("Game duration:", game.gameDuration());
        console.log("Game max rounds:", game.gameCount()); // Note: this might be 0 initially
        
        // Approve and join as player 1
        uint256 playerAmount = game.tokenAmount() / 2;
        console.log("Amount needed per player:", playerAmount);
        
        gameToken.approve(gameAddress, playerAmount);
        console.log("Approved tokens for game");
        
        game.joinGame();
        console.log("Joined game as player 1");
        
        // Check game state
        console.log("Player1:", game.player1());
        console.log("Player2:", game.player2());
        console.log("Game contract balance:", gameToken.balanceOf(gameAddress));
        
        // Show commit/reveal example (can't actually execute without player 2)
        console.log("\n=== COMMIT/REVEAL EXAMPLE ===");
        
        // Example of how to create a commitment
        uint256 nonce = 12345;
        Choice choice = Choice.Cooperate;
        bytes32 commitment = keccak256(abi.encodePacked(choice, nonce));
        
        console.log("Example commitment calculation:");
        console.log("Choice: Cooperate (1)");
        console.log("Nonce:", nonce);
        console.log("Commitment hash:");
        console.logBytes32(commitment);
        
        console.log("\nTo commit this choice, call:");
        console.log("game.commitChoice(commitment)");
        console.log("\nTo reveal, call:");
        console.log("game.revealChoice(Choice.Cooperate, nonce)");
    }
    
    function showAPITestingInstructions(address gameAddress) internal view {
        console.log("\n=== API TESTING INSTRUCTIONS ===");
        console.log("You can now test the backend API endpoints:");
        console.log("");
        console.log("1. Get all games:");
        console.log("   curl http://localhost:3000/games");
        console.log("");
        console.log("2. Get specific game details:");
        console.log("   curl http://localhost:3000/games/%s", gameAddress);
        console.log("");
        console.log("3. Get game rounds:");
        console.log("   curl http://localhost:3000/games/%s/rounds", gameAddress);
        console.log("");
        console.log("4. Get games for player:");
        console.log("   curl http://localhost:3000/games/player/YOUR_ADDRESS");
        console.log("");
        console.log("5. Get game count:");
        console.log("   curl http://localhost:3000/game-factory/game-count");
        console.log("");
        console.log("6. Get token info:");
        console.log("   curl http://localhost:3000/game-token/token-info");
    }
}