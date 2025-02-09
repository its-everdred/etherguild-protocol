forge script script/1_DeployQuestFactory.s.sol --chain sepolia --rpc-url x --etherscan-api-key x --verify --broadcast

[⠊] Compiling...
No files changed, compilation skipped
Script ran successfully.

== Return ==
0: address 0x7db2542D15AC68C9958E8d73f32641Ed9714Fd6f

== Logs ==
  QuestFactory deployed to: 0x7db2542D15AC68C9958E8d73f32641Ed9714Fd6f

## Setting up 1 EVM.

==========================

Chain 11155111

Estimated gas price: 19.637747512 gwei

Estimated total gas used for script: 1885305

Estimated amount required: 0.03702314357311116 ETH

==========================

##### sepolia
✅  [Success] Hash: 0x4a3feb0dc27479b8d4e23f229f63175415a97323e3c074adf339f686be645de4
Contract Address: 0x7db2542D15AC68C9958E8d73f32641Ed9714Fd6f
Block: 7671360
Paid: 0.014693441869493135 ETH (1450235 gas * 10.131766141 gwei)

✅ Sequence #1 on sepolia | Total Paid: 0.014693441869493135 ETH (1450235 gas * avg 10.131766141 gwei)
                                                                                                                                    

==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
##
Start verification for (1) contracts
Start verifying contract `0x7db2542D15AC68C9958E8d73f32641Ed9714Fd6f` deployed on sepolia
Compiler version: 0.8.28
Optimizations:    200

Submitting verification for [src/QuestFactory.sol:QuestFactory] 0x7db2542D15AC68C9958E8d73f32641Ed9714Fd6f.
Warning: Etherscan could not detect the deployment.; waiting 5 seconds before trying again (4 tries remaining)
 D
Submitting verification for [src/QuestFactory.sol:QuestFactory] 0x7db2542D15AC68C9958E8d73f32641Ed9714Fd6f.
Warning: Etherscan could not detect the deployment.; waiting 5 seconds before trying again (3 tries remaining)

Submitting verification for [src/QuestFactory.sol:QuestFactory] 0x7db2542D15AC68C9958E8d73f32641Ed9714Fd6f.
Warning: Etherscan could not detect the deployment.; waiting 5 seconds before trying again (2 tries remaining)

Submitting verification for [src/QuestFactory.sol:QuestFactory] 0x7db2542D15AC68C9958E8d73f32641Ed9714Fd6f.
Warning: Etherscan could not detect the deployment.; waiting 5 seconds before trying again (1 tries remaining)

Submitting verification for [src/QuestFactory.sol:QuestFactory] 0x7db2542D15AC68C9958E8d73f32641Ed9714Fd6f.
Submitted contract for verification:
        Response: `OK`
        GUID: `htrlj4vzbfruwbx35f4xw2f5s68eb29pvnac8kccxvutfiuqma`
        URL: https://sepolia.etherscan.io/address/0x7db2542d15ac68c9958e8d73f32641ed9714fd6f
Contract verification status:
Response: `NOTOK`
Details: `Pending in queue`
Warning: Verification is still pending...; waiting 15 seconds before trying again (7 tries remaining)
Contract verification status:
Response: `OK`
Details: `Pass - Verified`
Contract successfully verified
All (1) contracts were verified!

Transactions saved to: /home/amsel/etherguild-contracts/broadcast/1_DeployQuestFactory.s.sol/11155111/run-latest.json

Sensitive values saved to: /home/amsel/etherguild-contracts/cache/1_DeployQuestFactory.s.sol/11155111/run-latest.json