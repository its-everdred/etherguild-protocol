// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {QuestDonation} from "../src/QuestDonation.sol";

contract SetupQuestScript is Script, Helper {
    function run(address questDonationAddress) external {
        uint256 deployerPrivateKey = getDeployerPrivateKey();
        vm.startBroadcast(deployerPrivateKey);

        QuestDonation questDonation = QuestDonation(questDonationAddress);

        // Allow tokens
        // ETH is not already allowed by default
        questDonation.allowToken(address(0), true);
        questDonation.allowToken(USDC, true);
        console.log("ETH address(0) and USDC set as allowed tokens");

        // Set price oracles
        questDonation.setPriceOracle(address(0), ETH_USD_FEED); // For Native ETH
        questDonation.setPriceOracle(USDC, USDC_USD_FEED); // USDC Oracle
        console.log("Price oracles set for ETH and USDC");

        vm.stopBroadcast();
    }
}
