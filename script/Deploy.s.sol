//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Helper} from "./Helper.sol";
import {DeployQuestFactoryScript} from "./1_DeployQuestFactory.s.sol";
import {SetupQuestFactoryScript} from "./2_SetupQuestFactory.s.sol";
import {CreateQuestDonationScript} from "./3_CreateQuestDonation.s.sol";
import {InteractionQuestScript} from "./4_InteractionQuest.s.sol";

contract DeployScript is Helper {
    function run() external {
        //DEPLOYS FACTORY AND FIRST EXAMPLE QUEST
        DeployQuestFactoryScript deployQuest = new DeployQuestFactoryScript();
        // address factoryAddress =
        deployQuest.run();

        // ALLOW TOKENS AND ADD ORACLE
        SetupQuestFactoryScript setupQuest = new SetupQuestFactoryScript();
        setupQuest.run();

        // CREATES FIRST QUEST
        CreateQuestDonationScript createQuest = new CreateQuestDonationScript();
        // address firstQuest =
        createQuest.run();

        // INTERACTING WITH FIRST QUEST
        InteractionQuestScript interactingQuest = new InteractionQuestScript();
        interactingQuest.run();
    }
}
