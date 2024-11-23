// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {GameFactory} from "../src/GameFactory.sol";
import {GameToken} from "../src/GameToken.sol";

contract DeployDillemaGame is Script {
    function run() external returns (GameFactory) {
        vm.startBroadcast(
            0x0fa13b1e8cbd46ac7f9450e71d5eed1f8213d3df1b289da24ed23fc84ca94349
        );

        GameToken gameToken = new GameToken("gameTk", "GTK");
        GameFactory gameFactory = new GameFactory();

        vm.stopBroadcast();

        return gameFactory;
    }
}
