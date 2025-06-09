// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {GameFactory} from "../src/GameFactory.sol";
import {GameToken} from "../src/GameToken.sol";

contract DeployDillemaGame is Script {
    function run() external returns (GameFactory, GameToken) {
        vm.startBroadcast();

        GameToken gameToken = new GameToken("Dilema Game Token", "DGT");
        GameFactory gameFactory = new GameFactory();

        vm.stopBroadcast();

        return (gameFactory, gameToken);
    }
}
