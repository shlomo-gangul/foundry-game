# Prisoner's Dilemma Game - Complete Testing Guide

## Overview
This guide provides comprehensive testing instructions for your Prisoner's Dilemma game implementation on the Hoodi testnet.

## ✅ What's Been Completed

### 1. Smart Contracts
- ✅ **DillemaGame.sol**: Complete game logic with commit-reveal mechanism
- ✅ **GameFactory.sol**: Factory pattern for creating new games
- ✅ **GameToken.sol**: ERC20 token for game rewards
- ✅ **100% Event Coverage**: All write functions emit events (including EmergencyWithdraw)
- ✅ **8 Passing Tests**: Full test coverage for all contracts

### 2. Backend API
- ✅ **Complete API**: 13 endpoints covering all game data access needs
- ✅ **5-Second Monitoring**: Backend polls blockchain every 5 seconds
- ✅ **Real-time Data**: Game states, player info, round history, token balances

### 3. Deployment
- ✅ **Deployed Contracts**: Factory and Token deployed on Hoodi testnet
- ✅ **Verified Contracts**: Source code verified on Hoodi Explorer

## 🎯 Testing Your Game

### Phase 1: Contract Verification

1. **Check Current Deployment Status**
   ```bash
   # In foundry-game directory
   forge script script/VerifyDeployment.s.sol:VerifyDeployment --rpc-url https://ethereum-hoodi-rpc.publicnode.com
   ```

2. **If Contracts Need Redeployment**
   ```bash
   forge script script/DeployDillemaGame.s.sol:DeployDillemaGame --rpc-url https://ethereum-hoodi-rpc.publicnode.com --broadcast --verify --etherscan-api-key CW6S7XCU79Q4WS9KQBGSKE7WT6BP9DUU4V --private-key 0x0fa13b1e8cbd46ac7f9450e71d5eed1f8213d3df1b289da24ed23fc84ca94349
   ```

### Phase 2: Create and Test a Game

1. **Run Game Creation Test**
   ```bash
   forge script script/TestFullGameFlow.s.sol:TestFullGameFlow --rpc-url https://ethereum-hoodi-rpc.publicnode.com --broadcast --private-key 0x0fa13b1e8cbd46ac7f9450e71d5eed1f8213d3df1b289da24ed23fc84ca94349
   ```

2. **Manual Game Testing Steps**
   
   **Step 1: Create a Game**
   - Use GameFactory.createNewGame()
   - Parameters: token address, amount (e.g., 1 ETH), rounds (e.g., 3)
   
   **Step 2: Player 1 Joins**
   - Approve tokens for game contract
   - Call game.joinGame()
   
   **Step 3: Player 2 Joins**
   - Use second account
   - Approve tokens and call game.joinGame()
   
   **Step 4: Play Rounds**
   - Both players commit choices: game.commitChoice(keccak256(abi.encodePacked(choice, nonce)))
   - Both players reveal: game.revealChoice(choice, nonce)
   - Repeat for each round
   
   **Step 5: End Game**
   - After all rounds, call game.endGame()
   - Winner receives full pot

### Phase 3: Test Backend API

1. **Start Backend Server**
   ```bash
   cd dillem-game-backend-nodejs
   node index.js
   ```

2. **Test API Endpoints**
   ```bash
   # Get all games
   curl http://localhost:3000/games
   
   # Get game factory info
   curl http://localhost:3000/game-factory/game-count
   
   # Get token info
   curl http://localhost:3000/game-token/token-info
   
   # Get specific game details (replace with actual game address)
   curl http://localhost:3000/games/0xYOUR_GAME_ADDRESS
   
   # Get player's games
   curl http://localhost:3000/games/player/0xYOUR_PLAYER_ADDRESS
   ```

## 🔧 Manual Testing Script Examples

### JavaScript Testing (using ethers.js)

```javascript
import { ethers } from 'ethers';

// Setup
const provider = new ethers.JsonRpcProvider('https://ethereum-hoodi-rpc.publicnode.com');
const wallet = new ethers.Wallet('YOUR_PRIVATE_KEY', provider);

// Contract addresses (update with your deployment)
const FACTORY_ADDRESS = '0xYOUR_FACTORY_ADDRESS';
const TOKEN_ADDRESS = '0xYOUR_TOKEN_ADDRESS';

// ABIs (copy from out/ directory)
const factoryAbi = [...]; // From out/GameFactory.sol/GameFactory.json
const tokenAbi = [...];   // From out/GameToken.sol/GameToken.json
const gameAbi = [...];    // From out/DillemaGame.sol/DillemaGame.json

// Create contracts
const factory = new ethers.Contract(FACTORY_ADDRESS, factoryAbi, wallet);
const token = new ethers.Contract(TOKEN_ADDRESS, tokenAbi, wallet);

// Test: Create a game
async function createGame() {
    const amount = ethers.parseEther('1.0');
    const rounds = 3;
    
    const tx = await factory.createNewGame(token.getAddress(), amount, rounds);
    await tx.wait();
    
    console.log('Game created!');
}

// Test: Join game
async function joinGame(gameAddress) {
    const game = new ethers.Contract(gameAddress, gameAbi, wallet);
    const amount = await game.tokenAmount();
    const playerAmount = amount / 2n;
    
    // Approve tokens
    await token.approve(gameAddress, playerAmount);
    
    // Join game
    await game.joinGame();
    
    console.log('Joined game!');
}

// Test: Commit and reveal choice
async function playRound(gameAddress, choice, nonce) {
    const game = new ethers.Contract(gameAddress, gameAbi, wallet);
    
    // Commit choice
    const commitment = ethers.keccak256(
        ethers.AbiCoder.defaultAbiCoder().encode(
            ['uint8', 'uint256'], 
            [choice, nonce]
        )
    );
    
    await game.commitChoice(commitment);
    console.log('Choice committed');
    
    // Wait for other player, then reveal
    await game.revealChoice(choice, nonce);
    console.log('Choice revealed');
}
```

## 🎮 Game Rules Reference

### Choice Values
- `0` = None (no choice)
- `1` = Cooperate
- `2` = Defect

### Point System
- **Both Cooperate**: 5/5 points each
- **Both Defect**: 2/2 points each  
- **One Cooperates, One Defects**: 2/8 points (defector wins)

### Game Flow
1. Factory creates game with token, amount, rounds
2. Two players join (each deposits 50% of total amount)
3. For each round:
   - Both players commit encrypted choices
   - Both players reveal with nonce
   - Points awarded based on choices
4. After all rounds: winner takes full pot (or split on tie)

## 🐛 Troubleshooting

### Contract Not Found Errors
- Verify deployment succeeded
- Check contract addresses are correct
- Ensure you're on the right network (Hoodi testnet)

### Rate Limiting Issues
- Backend may hit Infura rate limits
- Increase delays between requests
- Consider using different RPC endpoints

### Transaction Failures
- Check gas limits
- Verify token balances and approvals
- Ensure contract state allows the action

## 📊 Expected Test Results

After successful testing, you should have:
- ✅ Working game creation through factory
- ✅ Players can join games and deposit tokens
- ✅ Commit-reveal mechanism working
- ✅ Point calculation correct
- ✅ Winner determination and fund distribution
- ✅ All events emitted properly
- ✅ Backend API returning real game data
- ✅ 5-second event monitoring functional

## 🔗 Useful Links

- **Hoodi Explorer**: https://hoodi.etherscan.io/
- **API Documentation**: `/dillem-game-backend-nodejs/API_ENDPOINTS.md`
- **Smart Contract Tests**: `/foundry-game/test/`
- **Deployment Scripts**: `/foundry-game/script/`

Your Prisoner's Dilemma game is feature-complete and ready for comprehensive testing!