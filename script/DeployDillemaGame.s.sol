// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {DillemaGame} from "../src/DillemaGame.sol";
import {GameToken} from "../src/GameToken.sol";

contract DeployDillemaGame is Script {
    function run() external returns (DillemaGame) {
        vm.startBroadcast();

        GameToken gameToken = new GameToken("gameTk", "GTK");
        DillemaGame dillemaGame = new DillemaGame(gameToken, 4e18, 5);

        vm.stopBroadcast();

        return dillemaGame;
    }
}
