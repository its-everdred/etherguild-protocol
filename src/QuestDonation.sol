// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract QuestDonation is Ownable {
    using SafeERC20 for IERC20;

    address public multisig;
    AggregatorV3Interface public priceOracle; // ETH/USD price feed
    uint256 public constant MAX_DONATION = 5000 * 1e18; // $5000 worth
    uint256 public constant YEAR = 365 days;

    mapping(address => uint256) public yearlyDonations;
    mapping(address => uint256) public lastDonationTimestamp;
    mapping(address => bool) public allowedTokens;

    event DonationReceived(address indexed donor, address indexed token, uint256 amount, uint256 usdValue);
    event TokenAllowed(address token, bool status);
    event FundsWithdrawn(address indexed token, uint256 amount);

    constructor(address _multisig, address _priceOracle) Ownable(msg.sender) {
        require(_multisig != address(0), "Invalid multisig address");
        require(_priceOracle != address(0), "Invalid oracle address");
        
        multisig = _multisig;
        priceOracle = AggregatorV3Interface(_priceOracle);
    }

    modifier withinDonationLimit(uint256 ethAmount) {
        (, int256 price, , , ) = priceOracle.latestRoundData();
        require(price > 0, "Invalid price");
        uint256 usdValue = (ethAmount * uint256(price)) / 1e8; // Convert to USD
        
        uint256 lastYear = lastDonationTimestamp[msg.sender];
        if (block.timestamp - lastYear > YEAR) {
            yearlyDonations[msg.sender] = 0;
            lastDonationTimestamp[msg.sender] = block.timestamp;
        }
        require(yearlyDonations[msg.sender] + usdValue <= MAX_DONATION, "Donation exceeds $5000/year. Contact info@etherguild.xyz");
        
        yearlyDonations[msg.sender] += usdValue;
        _;
    }

    function donateETH() external payable withinDonationLimit(msg.value) {
        require(msg.value > 0, "Donation amount must be greater than 0");
        (, int256 price, , , ) = priceOracle.latestRoundData();
        emit DonationReceived(msg.sender, address(0), msg.value, msg.value * uint256(price) / 1e8);
    }

    function donateERC20(address token, uint256 amount) external withinDonationLimit(amount) {
        require(allowedTokens[token], "Token not allowed");
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        emit DonationReceived(msg.sender, token, amount, amount);
    }

    function allowToken(address token, bool status) external onlyOwner {
        allowedTokens[token] = status;
        emit TokenAllowed(token, status);
    }

    function withdraw(address token, uint256 amount) external {
        require(msg.sender == multisig, "Only multisig can withdraw");
        if (token == address(0)) {
            payable(multisig).transfer(amount);
        } else {
            IERC20(token).safeTransfer(multisig, amount);
        }
        emit FundsWithdrawn(token, amount);
    }
}
