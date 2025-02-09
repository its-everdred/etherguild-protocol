// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.24;
import {Script} from "forge-std/Script.sol";


contract Helper is Script{
    address constant USDC = 0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8;
    
    // Chainlink Price Feed addresses
    address constant ETH_USD_FEED = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address constant USDC_USD_FEED = 0xA2F78ab2355fe2f984D808B5CeE7FD0A93D5270E;
    error InvalidPrivateKey(string);


    function getDeployerPrivateKey() internal view returns (uint256 deployerPrivateKey) {
        deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }
    }


}