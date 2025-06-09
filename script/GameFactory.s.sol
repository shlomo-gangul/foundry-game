// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

/**
 * @title AnvilEthTransferScript
 * @dev Script for transferring ETH between accounts and displaying balances
 */
contract AnvilEthTransferScript is Script {
    // Addresses to use for transfers (default Anvil addresses)
    address public constant WALLET1 = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // First Anvil account
    address public constant WALLET2 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8; // Second Anvil account

    /**
     * @dev Main function that is executed when the script runs
     */
    function run() external {
        // Start by printing information
        console.log("Starting Anvil ETH Transfer Script");

        // Check if we're on a local Anvil chain
        require(block.chainid == 31337, "This script is designed to run on Anvil");

        // Set up the private key for the first wallet (Anvil's default first account)
        uint256 privateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

        // Get initial balances
        uint256 wallet1InitialBalance = address(WALLET1).balance;
        uint256 wallet2InitialBalance = address(WALLET2).balance;

        console.log("Initial Balances:");
        console.log("Wallet 1 (%s): %s ETH", WALLET1, wallet1InitialBalance / 1e18);
        console.log("Wallet 2 (%s): %s ETH", WALLET2, wallet2InitialBalance / 1e18);

        // Start broadcast with the private key to perform transactions
        vm.startBroadcast(privateKey);

        // Send 1 ETH from WALLET1 to WALLET2
        uint256 amountToSend = 1 ether;

        console.log("Sending %s ETH from Wallet 1 to Wallet 2...", amountToSend / 1e18);

        // Perform the transfer
        (bool success,) = WALLET2.call{value: amountToSend}("");
        require(success, "Transfer failed");

        vm.stopBroadcast();

        // Get final balances
        uint256 wallet1FinalBalance = address(WALLET1).balance;
        uint256 wallet2FinalBalance = address(WALLET2).balance;

        console.log("Final Balances:");
        console.log("Wallet 1 (%s): %s ETH", WALLET1, wallet1FinalBalance / 1e18);
        console.log("Wallet 2 (%s): %s ETH", WALLET2, wallet2FinalBalance / 1e18);

        console.log("Balance Changes:");
        // For Wallet 1 (which will have a negative change)
        int256 wallet1Change = int256(wallet1FinalBalance) - int256(wallet1InitialBalance);
        console.log("Wallet 1: %s ETH", wallet1Change / 1e18);

        // For Wallet 2 (which will have a positive change)
        int256 wallet2Change = int256(wallet2FinalBalance) - int256(wallet2InitialBalance);
        console.log("Wallet 2: %s ETH", wallet2Change / 1e18);
        console.log("Transaction completed successfully!");
    }
}
