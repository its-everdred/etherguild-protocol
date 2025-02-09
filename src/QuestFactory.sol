// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./QuestDonation.sol"; 

contract QuestFactory {
    address public admin;

    constructor() {
        admin = msg.sender;  // Set contract deployer as admin
    }

    // Structure to store quest details
    struct Quest {
        address questContract;
        uint256 targetAmount;
        address creator;
        uint256 timestamp;
    }

    // Array to store all quests
    Quest[] public quests;

    // Event emitted when new quest is created
    event QuestCreated(
        address indexed questContract,
        address indexed creator,
        uint256 timestamp
    );

    // Function to create new quest
    function createQuest(
        uint256 _targetAmount
    ) external returns (address) {
        // Deploy new QuestDonation contract
        QuestDonation newQuest = new QuestDonation(
            admin,
            _targetAmount,
            msg.sender
        );

        // Store quest details
        quests.push(
            Quest({
                questContract: address(newQuest),
                targetAmount: _targetAmount,
                creator: msg.sender,
                timestamp: block.timestamp
            })
        );

        // Emit event
        emit QuestCreated(
            address(newQuest),
            msg.sender,
            block.timestamp
        );

        return address(newQuest);
    }

    // Get total number of quests
    function getQuestsCount() external view returns (uint256) {
        return quests.length;
    }

    // Get quest by index
    function getQuestByIndex(uint256 _index) external view returns (
        address questContract,
        uint256 targetAmount,
        address creator,
        uint256 timestamp
    ) {
        require(_index < quests.length, "Quest index out of bounds");
        Quest memory quest = quests[_index];
        return (
            quest.questContract,
            quest.targetAmount,
            quest.creator,
            quest.timestamp
        );
    }
}
