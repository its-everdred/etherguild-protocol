// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {QuestDonation} from "../src/QuestDonation.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract InteractionQuestScript is Script, Helper {
    function run() external {
        address questDonationAddress = vm.envAddress("DONATION_ADDRESS");

        uint256 deployerPrivateKey = getDeployerPrivateKey();
        vm.startBroadcast(deployerPrivateKey);

        QuestDonation questDonation = QuestDonation(questDonationAddress);

        // DEPLOYER WALLET
        // CHECK ETH BALANCE
        address deployerAddress = vm.addr(deployerPrivateKey);
        console.log("Address:", deployerAddress);
        console.log("ETH Balance: ", deployerAddress.balance / 10 ** 18);
        // CHECK USDC BALANCE
        console.log("USDC balance:", IERC20(USDC).balanceOf(address(deployerAddress)) / 10 ** 6);

        // Make donations
        // ETH donation
        questDonation.donateETH{value: 0.01 ether}(); // Donate ETH
        console.log("Donated 0.01 ETH");

        // USDC donation
        uint256 usdcAmount = 1 * 10 ** 6;
        IERC20(USDC).approve(address(questDonation), usdcAmount); // DONATE USDC
        questDonation.donateERC20(USDC, usdcAmount);
        console.log("Donated 1 USDC");

        // Log balances after donations
        console.log("===QUEST CONTRACT: Balances after donations ===");
        console.log("ETH balance:", address(questDonation).balance);
        console.log("USDC balance:", IERC20(USDC).balanceOf(address(questDonation)));

        // Withdraw funds
        uint256 ethBalance = address(questDonation).balance;
        uint256 usdcBalance = IERC20(USDC).balanceOf(address(questDonation));

        if (ethBalance > 0) {
            questDonation.withdraw(address(0), ethBalance / 2); // WITHDRAW ETH
            console.log("Withdrawn ETH balance:", ethBalance / 2);
        }

        if (usdcBalance > 0) {
            questDonation.withdraw(USDC, usdcBalance / 2); // EITHDRAW USDC
            console.log("Withdrawn USDC balance:", usdcBalance / 2);
        }

        // Log balances after withdrawals
        console.log("===QUEST CONTRACT: Balances after withdrawals ===");
        console.log("ETH balance:", address(questDonation).balance);
        console.log("USDC balance:", IERC20(USDC).balanceOf(address(questDonation)));

        vm.stopBroadcast();
    }
}
