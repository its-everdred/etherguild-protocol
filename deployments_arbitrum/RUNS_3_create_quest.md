export FACTORY_ADDRESS="0x0"

`forge script script/3_CreateQuestDonation.s.sol --chain arbitrum --rpc-url x --etherscan-api-key x --broadcast --verify`

[⠊] Compiling...
[⠆] Compiling 1 files with Solc 0.8.24
[⠰] Solc 0.8.24 finished in 1.30s
Compiler run successful!
Script ran successfully.

== Return ==
questDonationAddress: address 0x8732384BcEb0C864E9865c96ff755b64767bCB17

== Logs ==
  QuestDonation deployed to: 0x8732384BcEb0C864E9865c96ff755b64767bCB17

## Setting up 1 EVM.

==========================

Chain 42161

Estimated gas price: 0.020000001 gwei

Estimated total gas used for script: 2124844

Estimated amount required: 0.000042496882124844 ETH

==========================

##### arbitrum
✅  [Success] Hash: 0x15e9d365dfbd1ffb50c9622c79d0a6618498759e81ce999578ea29ec0ff81b59
Block: 304443365
Paid: 0.00001619253 ETH (1619253 gas * 0.01 gwei)

✅ Sequence #1 on arbitrum | Total Paid: 0.00001619253 ETH (1619253 gas * avg 0.01 gwei)
                                                                                                                                                                                       

==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
##
Start verification for (1) contracts
Start verifying contract `0x8732384BcEb0C864E9865c96ff755b64767bCB17` deployed on arbitrum
Compiler version: 0.8.24
Constructor args: 000000000000000000000000cd949192344f41de8d99336a4f32bb0b9c04e5770000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000cd949192344f41de8d99336a4f32bb0b9c04e57700000000000000000000000084bc865b9c806dcc70ab8b948fee73e7ba4b3062

Submitting verification for [src/QuestDonation.sol:QuestDonation] 0x8732384BcEb0C864E9865c96ff755b64767bCB17.
Submitted contract for verification:
        Response: `OK`
        GUID: `lifqjypjjcpqiycqpx7ebnumwe47ufqyjv9zv9pbqbevm7kuwv`
        URL: https://arbiscan.io/address/0x8732384bceb0c864e9865c96ff755b64767bcb17
Contract verification status:
Response: `NOTOK`
Details: `Pending in queue`
Warning: Verification is still pending...; waiting 15 seconds before trying again (7 tries remaining)
Contract verification status:
Response: `OK`
Details: `Pass - Verified`
Contract successfully verified
All (1) contracts were verified!

Transactions saved to: /Users/abin/Desktop/etherguild-protocol/broadcast/3_CreateQuestDonation.s.sol/42161/run-latest.json

Sensitive values saved to: /Users/abin/Desktop/etherguild-protocol/cache/3_CreateQuestDonation.s.sol/42161/run-latest.json