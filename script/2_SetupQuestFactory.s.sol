// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {QuestDonation} from "../src/QuestDonation.sol";
import "../src/QuestFactory.sol";

contract SetupQuestFactoryScript is Script, Helper {
    function run() external {
        // Parse address argument from CLI
        // address factoryAddress = vm.parseAddress(vm.argString("factoryAddress"));
        address factoryAddress = vm.envAddress("FACTORY_ADDRESS");

        uint256 deployerPrivateKey = getDeployerPrivateKey();
        vm.startBroadcast(deployerPrivateKey);

        QuestFactory factory = QuestFactory(factoryAddress);
        factory.allowToken(address(0), true);
        factory.allowToken(USDC, true);
        console.log("ETH address(0) and USDC set as allowed tokens");

        factory.setPriceOracle(address(0), ETH_USD_FEED); // For Native ETH
        factory.setPriceOracle(USDC, USDC_USD_FEED); // USDC Oracle
        console.log("Price oracles set for ETH and USDC");

        vm.stopBroadcast();
    }
}
