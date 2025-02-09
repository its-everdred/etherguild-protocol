// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {QuestDonation} from "../src/QuestDonation.sol";
import {MockV3Aggregator} from "./mocks/MockV3Aggregator.sol";
import {MockERC20} from "./mocks/MockERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract QuestDonationTest is Test {
    QuestDonation public questDonation;
    MockV3Aggregator public mockPriceFeedETH;
    MockV3Aggregator public mockPriceFeedUSDC;
    MockERC20 public mockUSDC;
    address public owner;
    address public donor1;
    address public donor2;
    address public questReceiver;
    
    // ETH price of $2000
    int256 constant INITIAL_ETH_PRICE = 2000 * 1e8;
    int256 constant INITIAL_USDC_PRICE = 1 * 1e8;

    uint256 constant targetAmount = 1 ether;

    // Setup function runs before each test
    function setUp() public {
        owner = address(this);
        donor1 = makeAddr("donor1");
        donor2 = makeAddr("donor2");
        questReceiver = makeAddr("questReceiver");
        
        // Deploy and initialize mock price feed
        mockPriceFeedETH = new MockV3Aggregator(8, INITIAL_ETH_PRICE);
        mockPriceFeedUSDC = new MockV3Aggregator(8, INITIAL_USDC_PRICE);
        
        // Deploy mock USDC token
        mockUSDC = new MockERC20("Mock USDC", "USDC", 6);
        
        // Deploy QuestDonation contract with mock params
        questDonation = new QuestDonation(owner, targetAmount, owner);
        
        // Allow ETH, USDC and set oracle
        questDonation.allowToken(address(0), true); // Replace address(0) with the actual token address if needed
        questDonation.setPriceOracle(address(0), address(mockPriceFeedETH)); // Assuming setPriceOracle is a function in QuestDonation

        questDonation.allowToken(address(mockUSDC), true);
        questDonation.setPriceOracle(address(mockUSDC), address(mockPriceFeedUSDC));

        // Fund test addresses with ETH
        vm.deal(donor1, 10 ether);
        vm.deal(donor2, 10 ether);
        
        // Fund donor1 with mock USDC
        vm.prank(owner);
        mockUSDC.mint(donor1, 1000 * 1e6);

        // Approve QuestDonation to spend USDC on behalf of donor1
        vm.prank(donor1);
        mockUSDC.approve(address(questDonation), 1000 * 1e6);
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
        
        // Withdraw as owner
        vm.prank(owner);
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
        vm.prank(owner);
        vm.expectRevert();
        questDonation.withdraw(address(0), 1 ether);
    }

    function testDonationWithUSDC() public {
        uint256 donationAmount = 500 * 1e6; // 1000 USDC
        
        // Simulate USDC transfer to QuestDonation contract
        vm.prank(donor1);
        // mockUSDC.approve(address(questDonation), donationAmount);
        questDonation.donateERC20(address(mockUSDC), donationAmount);
        
        // Assert donation was recorded correctly
        assertEq(IERC20(mockUSDC).balanceOf(address(questDonation)), donationAmount);
    }

    function testWithdrawalWithUSDC() public {
        uint256 donationAmount = 200 * 1e6;
        
        // Simulate USDC transfer to QuestDonation contract
        vm.prank(donor1);
        // mockUSDC.approve(address(questDonation), donationAmount);
        questDonation.donateERC20(address(mockUSDC), donationAmount);
        
        // Withdraw as owner
        vm.prank(owner);
        questDonation.withdraw(address(mockUSDC), donationAmount);
        
        // Assert withdrawal was successful
        assertEq(mockUSDC.balanceOf(address(questDonation)), 0);
    }

    receive() external payable {}
}
