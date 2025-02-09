//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Helper} from "./Helper.sol";
import {DeployQuestScript} from "./1_DeployQuest.s.sol";
import {SetupQuestScript} from "./2_SetupQuest.s.sol";
import {InteractionQuestScript} from "./3_InteractionQuest.s.sol";

contract DeployScript is Helper {
    function run() external {

        //DEPLOYS FACTORY AND FIRST EXAMPLE QUEST
        DeployQuestScript deployQuest = new DeployQuestScript();
        ( , address firstQuest) = deployQuest.run();

        // ALLOW TOKENS AND ADD ORACLE
        SetupQuestScript setupQuest = new SetupQuestScript();
        setupQuest.run(firstQuest);

        // INTERACTING WITH FIRST QUEST
        InteractionQuestScript interactingQuest = new InteractionQuestScript();
        interactingQuest.run(firstQuest);
        
    }
}