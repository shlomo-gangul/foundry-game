require("dotenv").config();
const express = require("express");
const { ethers } = require("ethers");
const app = express();
const port = 3000;

// Load environment variables
const infuraProjectId = process.env.INFURA_PROJECT_ID;
const privateKey = process.env.PRIVATE_KEY;
const gameFactoryAddress = process.env.GAME_FACTORY_ADDRESS;

// Set up the provider and wallet
const provider = new ethers.JsonRpcProvider(infuraProjectId);
const wallet = new ethers.Wallet(privateKey, provider);

// ABI of the GameFactory contract
const gameFactoryAbi = [
  {
    inputs: [],
    name: "createNewGame",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "getGameCount",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "index",
        type: "uint256",
      },
    ],
    name: "getGame",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

// Create a contract instance
const gameFactory = new ethers.Contract(
  gameFactoryAddress,
  gameFactoryAbi,
  wallet
);

// Middleware to parse JSON requests
app.use(express.json());

// Endpoint to create a new game
app.post("/create-game", async (req, res) => {
  try {
    const tx = await gameFactory.createNewGame();
    await tx.wait();
    res.json({ message: "New game created" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred" });
  }
});

// Endpoint to get the game count
app.get("/game-count", async (req, res) => {
  try {
    const gameCount = await gameFactory.getGameCount();
    res.json({ gameCount: gameCount.toString() });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred" });
  }
});

// Endpoint to get a game address by index
app.get("/game/:index", async (req, res) => {
  try {
    const gameAddress = await gameFactory.getGame(req.params.index);
    res.json({ gameAddress });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred" });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
