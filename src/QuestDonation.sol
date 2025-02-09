// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "./QuestFactory.sol";

contract QuestDonation is Ownable {
    using SafeERC20 for IERC20;

    QuestFactory public factory;

    address public admin;
    uint256 public targetAmount;
    address public creator;
    uint256 public constant MAX_DONATION = 5000 * 1e18; // $5000 worth
    uint256 public constant YEAR = 365 days;

    // Oracle mappings
    mapping(address => uint256) public yearlyDonations;
    mapping(address => uint256) public lastDonationTimestamp;

    event DonationReceived(address indexed donor, address indexed token, uint256 amount, uint256 usdValue);
    event FundsWithdrawn(address indexed token, uint256 amount);

    constructor(address _admin, uint256 _targetAmount, address _creator, QuestFactory _factory) Ownable(_admin) {
        require(_admin != address(0), "Invalid admin address");
        require(_creator != address(0), "Invalid creator address");
        require(_targetAmount > 0, "Invalid target amount");

        admin = _admin;
        targetAmount = _targetAmount;
        creator = _creator;
        factory = _factory;
    }

    modifier withinDonationLimit(address token, uint256 amount) {
        uint256 price = factory.getPrice(token);
        require(price > 0, "Invalid price");

        uint256 usdValue;
        if (token == address(0)) {
            // Native token (ETH) has 18 decimals
            usdValue = amount * price;
        } else {
            // For ERC20 tokens, get their decimals
            uint8 tokenDecimals = IERC20Metadata(token).decimals();
            // Adjust the calculation based on token decimals
            usdValue = (amount * price) / (10 ** tokenDecimals);
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
        uint256 price = factory.getPrice(address(0));
        emit DonationReceived(msg.sender, address(0), msg.value, msg.value * price);
    }

    function donateERC20(address token, uint256 amount) external withinDonationLimit(token, amount) {
        require(factory.isTokenAllowed(token), "Token not allowed");
        uint256 price = factory.getPrice(token);
        SafeERC20.safeTransferFrom(IERC20(token), msg.sender, address(this), amount);
        emit DonationReceived(msg.sender, token, amount, amount * price);
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
