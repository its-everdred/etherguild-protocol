export FACTORY_ADDRESS="0x0"

forge script script/3_CreateQuestDonation.s.sol --chain sepolia --rpc-url x --etherscan-api-key x --broadcast --verify
[⠊] Compiling...
No files changed, compilation skipped
Script ran successfully.

== Return ==
questDonationAddress: address 0xFd843f5158401a48a7689BbAe1976689c6582cdf

== Logs ==
  QuestDonation deployed to: 0xFd843f5158401a48a7689BbAe1976689c6582cdf

## Setting up 1 EVM.

==========================

Chain 11155111

Estimated gas price: 17.488031658 gwei

Estimated total gas used for script: 1210820

Estimated amount required: 0.02117485849213956 ETH

==========================

##### sepolia
✅  [Success] Hash: 0x105e076c0874f525868697cdb88b71abefad1f63f7b81289f259c55f74234335
Block: 7671437
Paid: 0.008521738795657032 ETH (876612 gas * 9.721220786 gwei)

✅ Sequence #1 on sepolia | Total Paid: 0.008521738795657032 ETH (876612 gas * avg 9.721220786 gwei)
                                                                                                                                    

==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
##
Start verification for (1) contracts
Start verifying contract `0xFd843f5158401a48a7689BbAe1976689c6582cdf` deployed on sepolia
Compiler version: 0.8.28
Optimizations:    200
Constructor args: 0000000000000000000000006a439b14f527d8731794b982d785b72f5d245c6f0000000000000000000000000000000000000000000000000de0b6b3a76400000000000000000000000000006a439b14f527d8731794b982d785b72f5d245c6f0000000000000000000000007db2542d15ac68c9958e8d73f32641ed9714fd6f

Submitting verification for [src/QuestDonation.sol:QuestDonation] 0xFd843f5158401a48a7689BbAe1976689c6582cdf.
Warning: Etherscan could not detect the deployment.; waiting 5 seconds before trying again (4 tries remaining)

Submitting verification for [src/QuestDonation.sol:QuestDonation] 0xFd843f5158401a48a7689BbAe1976689c6582cdf.
Warning: Etherscan could not detect the deployment.; waiting 5 seconds before trying again (3 tries remaining)

Submitting verification for [src/QuestDonation.sol:QuestDonation] 0xFd843f5158401a48a7689BbAe1976689c6582cdf.
Warning: Etherscan could not detect the deployment.; waiting 5 seconds before trying again (2 tries remaining)

Submitting verification for [src/QuestDonation.sol:QuestDonation] 0xFd843f5158401a48a7689BbAe1976689c6582cdf.
Submitted contract for verification:
        Response: `OK`
        GUID: `kkhvfmpkgcskw1ayggsskttl42uznvvgiyl9dmplgxgytx6ij5`
        URL: https://sepolia.etherscan.io/address/0xfd843f5158401a48a7689bbae1976689c6582cdf
Contract verification status:
Response: `NOTOK`
Details: `Pending in queue`
Warning: Verification is still pending...; waiting 15 seconds before trying again (7 tries remaining)
Contract verification status:
Response: `OK`
Details: `Pass - Verified`
Contract successfully verified
All (1) contracts were verified!

Transactions saved to: /home/amsel/etherguild-contracts/broadcast/3_CreateQuestDonation.s.sol/11155111/run-latest.json

Sensitive values saved to: /home/amsel/etherguild-contracts/cache/3_CreateQuestDonation.s.sol/11155111/run-latest.json