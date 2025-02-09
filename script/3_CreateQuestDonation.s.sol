// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {QuestFactory} from "../src/QuestFactory.sol";
import {QuestDonation} from "../src/QuestDonation.sol";

contract CreateQuestDonationScript is Script, Helper {
    function run() external returns (address questDonationAddress) {
        address factoryAddress = vm.envAddress("FACTORY_ADDRESS");

        uint256 deployerPrivateKey = getDeployerPrivateKey();
        vm.startBroadcast(deployerPrivateKey);

        QuestFactory factory = QuestFactory(factoryAddress);

        // Create a new Quest with a target amount (for example, 1 ether)
        // Msg.sender is the creator of the quest, but only admin can withdraw funds
        uint256 targetAmount = 1 ether;
        questDonationAddress = factory.createQuest(targetAmount);
        QuestDonation questDonation = QuestDonation(questDonationAddress);

        // Log deployed addresses
        console.log("QuestDonation deployed to:", address(questDonation));

        vm.stopBroadcast();

        // Return the address of the QuestDonation
    }
}
