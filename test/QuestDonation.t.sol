// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {QuestDonation} from "../src/QuestDonation.sol";
import {MockV3Aggregator} from "./mocks/MockV3Aggregator.sol";

contract QuestDonationTest is Test {
    QuestDonation public questDonation;
    address public mockPriceFeed;
    address public owner;
    address public donor1;
    address public donor2;
    address public questReceiver;
    
    // ETH price of $2000
    int256 constant INITIAL_PRICE = 2000 * 1e8;

    // Setup function runs before each test
    function setUp() public {
        owner = address(this);
        donor1 = makeAddr("donor1");
        donor2 = makeAddr("donor2");
        questReceiver = makeAddr("questReceiver");
        // Deploy and initialize mock price feed
        MockV3Aggregator mockPriceFeedContract = new MockV3Aggregator(8, INITIAL_PRICE);
        mockPriceFeed = address(mockPriceFeedContract);
        
        // Deploy QuestDonation contract with mock price feed
        questDonation = new QuestDonation(makeAddr("multisig"), mockPriceFeed);
        // Fund test addresses
        vm.deal(donor1, 10 ether);
        vm.deal(donor2, 10 ether);
    }

    function testDonation() public {
        uint256 donationAmount = 1 ether;
        
        // Test donation from donor1
        vm.prank(donor1);
        questDonation.donateETH{value: donationAmount}();
        
        // Assert donation was recorded correctly
        assertEq(address(questDonation).balance, donationAmount);
    }

    function testMultipleDonations() public {
        uint256 donation1 = 1 ether;
        uint256 donation2 = 2 ether;
        
        // First donation
        vm.prank(donor1);
        questDonation.donateETH{value: donation1}();
        
        // Second donation
        vm.prank(donor2);
        questDonation.donateETH{value: donation2}();
        
        // Assert total donations
        assertEq(address(questDonation).balance, donation1 + donation2);
    }

    function testWithdrawal() public {
        uint256 donationAmount = 1 ether;
        
        // Make donation
        vm.prank(donor1);
        questDonation.donateETH{value: donationAmount}();
        
        // Withdraw as multisig
        vm.prank(questDonation.multisig());
        questDonation.withdraw(address(0), donationAmount);
        
        // Assert withdrawal was successful
        assertEq(address(questDonation).balance, 0);
    }

    function test_RevertWhen_DonationAmountIsZero() public {
        vm.prank(donor1);
        vm.expectRevert();
        questDonation.donateETH{value: 0}();
    }

    function test_RevertWhen_WithdrawingWithNoDonations() public {
        vm.prank(questDonation.multisig());
        vm.expectRevert();
        questDonation.withdraw(address(0), 1 ether);
    }

    receive() external payable {}
}
