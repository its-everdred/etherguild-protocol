// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {QuestFactory} from "../src/QuestFactory.sol";

contract DeployQuestFactoryScript is Script, Helper {
    function run() external returns (address) {
        uint256 deployerPrivateKey = getDeployerPrivateKey();
        vm.startBroadcast(deployerPrivateKey);

        // Deploy QuestFactory with constructor parameters
        // Sets msg.sender as admin for factory and all future quests created
        QuestFactory questFactory = new QuestFactory();
        address questFactoryAddress = address(questFactory);

        // Log deployed addresses
        console.log("QuestFactory deployed to:", questFactoryAddress);

        vm.stopBroadcast();

        // Return the address of the QuestFactory
        return questFactoryAddress;
    }
}
