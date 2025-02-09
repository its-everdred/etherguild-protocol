// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract QuestDonation is Ownable {
    using SafeERC20 for IERC20;

    address public admin;
    uint256 public targetAmount;
    address public creator;
    uint256 public constant MAX_DONATION = 5000 * 1e18; // $5000 worth
    uint256 public constant YEAR = 365 days;

    // Oracle mappings
    mapping(address => AggregatorV3Interface) public priceOracles; // token => price feed
    mapping(address => uint256) public yearlyDonations;
    mapping(address => uint256) public lastDonationTimestamp;
    mapping(address => bool) public allowedTokens;

    event DonationReceived(address indexed donor, address indexed token, uint256 amount, uint256 usdValue);
    event TokenAllowed(address token, bool status);
    event FundsWithdrawn(address indexed token, uint256 amount);
    event PriceOracleSet(address indexed token, address indexed oracle);

    constructor(address _admin, uint256 _targetAmount, address _creator) Ownable(_admin) {
        require(_admin != address(0), "Invalid admin address");
        require(_creator != address(0), "Invalid creator address");
        require(_targetAmount > 0, "Invalid target amount");

        admin = _admin;
        targetAmount = _targetAmount;
        creator = _creator;
    }

    modifier withinDonationLimit(address token, uint256 amount) {
        require(address(priceOracles[token]) != address(0), "No price oracle set for token");
        AggregatorV3Interface priceFeed = priceOracles[token];
        (, int256 price,,,) = priceFeed.latestRoundData();
        uint8 priceDecimals = priceFeed.decimals();

        require(price > 0, "Invalid price");

        uint256 usdValue;
        if (token == address(0)) {
            // Native token (ETH) has 18 decimals
            usdValue = (amount * uint256(price)) / (10 ** priceDecimals);
        } else {
            // For ERC20 tokens, get their decimals
            uint8 tokenDecimals = IERC20Metadata(token).decimals();
            // Adjust the calculation based on token decimals
            usdValue = (amount * uint256(price)) / (10 ** tokenDecimals) / (10 ** priceDecimals);
        }

        uint256 lastYear = lastDonationTimestamp[msg.sender];
        if (block.timestamp - lastYear > YEAR) {
            yearlyDonations[msg.sender] = 0;
            lastDonationTimestamp[msg.sender] = block.timestamp;
        }
        require(
            yearlyDonations[msg.sender] + usdValue <= MAX_DONATION,
            "Donation exceeds $5000/year. Contact info@etherguild.xyz"
        );

        yearlyDonations[msg.sender] += usdValue;
        _;
    }

    function donateETH() external payable withinDonationLimit(address(0), msg.value) {
        require(msg.value > 0, "Donation amount must be greater than 0");
        AggregatorV3Interface priceFeed = priceOracles[address(0)];
        (, int256 price,,,) = priceFeed.latestRoundData();
        uint8 priceDecimals = priceFeed.decimals();
        emit DonationReceived(msg.sender, address(0), msg.value, msg.value * uint256(price) / (10 ** priceDecimals));
    }

    function donateERC20(address token, uint256 amount) external withinDonationLimit(token, amount) {
        require(allowedTokens[token], "Token not allowed");
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        AggregatorV3Interface priceFeed = priceOracles[token];
        (, int256 price,,,) = priceFeed.latestRoundData();
        uint8 priceDecimals = priceFeed.decimals();
        emit DonationReceived(msg.sender, token, amount, amount * uint256(price) / (10 ** priceDecimals));
    }

    function allowToken(address token, bool status) external onlyOwner {
        allowedTokens[token] = status;
        emit TokenAllowed(token, status);
    }

    // Example
    // Data Feed: ETH/USD
    // Address token: address(0), oracle: 0xchainlin
    function setPriceOracle(address token, address oracle) external onlyOwner {
        require(allowedTokens[token], "Token not allowed");
        require(oracle != address(0), "Invalid oracle address");

        priceOracles[token] = AggregatorV3Interface(oracle);
        emit PriceOracleSet(token, oracle);
    }

    function withdraw(address token, uint256 amount) external {
        require(msg.sender == admin, "Only admin can withdraw");
        if (token == address(0)) {
            payable(admin).transfer(amount);
        } else {
            IERC20(token).safeTransfer(admin, amount);
        }
        emit FundsWithdrawn(token, amount);
    }
}
