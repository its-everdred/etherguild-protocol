## ETHER GUILD PROTOCOL

Setup .env variables.
```
DEPLOYER_PRIVATE_KEY=0x1234
SEPOLIA_RPC_URL='https://...`
```

## Smart Contracts

- **src/QuestFactory**: msg.sender as Admin, allows anyone to create New Quest (factory admin will persist to Quest)
- **src/QuestDonation**: contructor params: @admin, @target, @creator

### Quest Donation
- MAX_DONATION(hardcoded): $5000/ year
- Admin Must `allowToken(token, status)` to set `setPriceOracle(token, oracle)`
- For Native ETH address(0) is used.


## Running the Script

To run the deployment script, use the following command:
```shell
$ forge script script/Deploy.s.sol --rpc-url sepolia
```

## Testing Smart Contracts

To test the smart contracts, execute:
```shell
$ forge test
```

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
