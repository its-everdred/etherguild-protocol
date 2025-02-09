// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

import "./QuestDonation.sol";

contract QuestFactory {
    address public admin;

    address[] public allowedTokens;

    // Mapping of token addresses to their corresponding price oracles
    mapping(address => AggregatorV3Interface) public priceOracles; // token => price feed

    // Mapping of token addresses to their corresponding prices
    mapping(address => uint256) public tokenPrices;

    // Mapping of token addresses to their corresponding allowed status
    mapping(address => bool) public isTokenAllowed;

    event TokenAllowed(address token, bool status);
    event PriceOracleSet(address indexed token, address indexed oracle);

    constructor() {
        admin = msg.sender; // Set contract deployer as admin
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
    event QuestCreated(address indexed questContract, address indexed creator, uint256 timestamp);

    // Function to create new quest
    function createQuest(uint256 _targetAmount) external returns (address) {
        // Deploy new QuestDonation contract
        QuestDonation newQuest = new QuestDonation(admin, _targetAmount, msg.sender, this);

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
        emit QuestCreated(address(newQuest), msg.sender, block.timestamp);

        return address(newQuest);
    }

    function allowToken(address token, bool status) external onlyOwner {
        if (status) {
            // Check if the token is already in the array
            bool tokenAlreadyAllowed = false;
            for (uint256 i = 0; i < allowedTokens.length; i++) {
                if (allowedTokens[i] == token) {
                    tokenAlreadyAllowed = true;
                    break;
                }
            }
            // Add the token only if it is not already in the array
            if (!tokenAlreadyAllowed) {
                allowedTokens.push(token);
            }
        } else {
            // Remove the token from the array
            for (uint256 i = 0; i < allowedTokens.length; i++) {
                if (allowedTokens[i] == token) {
                    allowedTokens[i] = allowedTokens[allowedTokens.length - 1];
                    allowedTokens.pop();
                    break;
                }
            }
        }
        isTokenAllowed[token] = status;
    }

    function getPrice(address token) public view returns (uint256) {
        require(isTokenAllowed[token], "Token not allowed");
        AggregatorV3Interface priceFeed = priceOracles[token];
        (, int256 price,,,) = priceFeed.latestRoundData();
        uint8 priceDecimals = priceFeed.decimals();
        return uint256(price) / (10 ** priceDecimals);
    }

    // Get total number of quests
    function getQuestsCount() external view returns (uint256) {
        return quests.length;
    }

    // Get quest by index
    function getQuestByIndex(uint256 _index)
        external
        view
        returns (address questContract, uint256 targetAmount, address creator, uint256 timestamp)
    {
        require(_index < quests.length, "Quest index out of bounds");
        Quest memory quest = quests[_index];
        return (quest.questContract, quest.targetAmount, quest.creator, quest.timestamp);
    }

    // Example
    // Data Feed: ETH/USD
    // Address token: address(0), oracle: 0xchainlink
    function setPriceOracle(address token, address oracle) external onlyOwner {
        require(isTokenAllowed[token], "Token not allowed");
        require(oracle != address(0), "Invalid oracle address");

        priceOracles[token] = AggregatorV3Interface(oracle);
        emit PriceOracleSet(token, oracle);
    }

    // Add a function to get allowed tokens
    function getAllowedTokens() external view returns (address[] memory) {
        return allowedTokens;
    }

    // Add a function to get price oracles
    function getPriceOracle(address token) external view returns (AggregatorV3Interface) {
        return priceOracles[token];
    }

    modifier onlyOwner() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }
}
