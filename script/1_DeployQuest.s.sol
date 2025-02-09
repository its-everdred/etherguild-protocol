// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {QuestFactory} from "../src/QuestFactory.sol";



contract DeployQuestScript is Script, Helper {

    function run() external returns (address questFactoryAddress, address questDonationAddress) {
        uint256 deployerPrivateKey = getDeployerPrivateKey();
        vm.startBroadcast(deployerPrivateKey);

        // Deploy QuestFactory with constructor parameters
        // Sets msg.sender as admin for factory and all future quests created
        QuestFactory questFactory = new QuestFactory();
        questFactoryAddress =  address(questFactory);

        // Create a new Quest with a target amount (for example, 1 ether)
        // Msg.sender is the creator of the quest, but only admin can withdraw funds
        uint256 targetAmount = 1 ether;
        questDonationAddress = questFactory.createQuest(targetAmount);

        // Log deployed addresses
        console.log("QuestFactory deployed to:", questFactoryAddress);
        console.log("QuestDonation deployed to:", questDonationAddress);

        vm.stopBroadcast();
    }

}
    