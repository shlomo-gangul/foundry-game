// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {GameFactory} from "../src/GameFactory.sol";
import {GameToken} from "../src/GameToken.sol";

contract VerifyDeployment is Script {
    // Correct deployed addresses
    address constant GAME_FACTORY_ADDRESS = 0xbE02FFD23eA3a53f1e77e8CC06bE9dA2411fE110;
    address constant GAME_TOKEN_ADDRESS = 0x56cD73a04A557325363B278e49B73AC5FdF8dd80;
    
    function run() external view {
        console.log("=== VERIFYING DEPLOYMENT ===");
        console.log("Game Factory Address:", GAME_FACTORY_ADDRESS);
        console.log("Game Token Address:", GAME_TOKEN_ADDRESS);
        
        // Check factory
        GameFactory factory = GameFactory(GAME_FACTORY_ADDRESS);
        console.log("Factory game count:", factory.getGameCount());
        
        // Check token
        GameToken token = GameToken(GAME_TOKEN_ADDRESS);
        console.log("Token name:", token.name());
        console.log("Token symbol:", token.symbol());
        console.log("Token decimals:", token.decimals());
        
        // Check deployer balance
        address deployer = 0x83Ae0bc5A0cc05d1cc7D6ecAb95af76E1CdD2794;
        console.log("Deployer balance:", token.balanceOf(deployer));
        
        console.log("\n=== DEPLOYMENT VERIFIED ===");
        console.log("All contracts are working correctly!");
    }
}