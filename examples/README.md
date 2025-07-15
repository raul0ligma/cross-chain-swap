# Running create_order.sh

This guide explains how to use the `create_order.sh` script to automate the deployment and management of cross-chain escrow contracts using Foundry, Anvil, and your project configuration.

## Prerequisites

- [Foundry](https://book.getfoundry.sh/) installed (`anvil`, `forge`, `cast` in your PATH)
- [jq](https://stedolan.github.io/jq/) installed for JSON parsing
- A valid `config.json` in `examples/config/` with all required fields (see below)
- (Optional) A working Ethereum RPC endpoint for forking

## Configuration

Edit `examples/config/config.json` to set up your deployment parameters. Example:

```json
{
  "escrowFactory": "0x...",         // address of escrow factory contract
  "limitOrderProtocol": "0x...",    // address of limit order protocol contract
  "deployer": "0x...",              // deployer address
  "deployerPK": "0x...",            // deployer private key
  "maker": "0x...",                 // maker address
  "makerPK": "0x...",               // maker private key
  "srcToken": "0x...",              // source chain token address
  "dstToken": "0x...",              // destination chain token address
  "resolver": "0x...",              // resolver address
  "srcAmount": 1,                   // source chain amount of srcToken
  "dstAmount": 1,                   // destination chain amount of dstToken
  "safetyDeposit": 1,               // safety deposit (same for src and dst chains)
  "resolverFee": 0,                 // resolver fee (charged by fee bank)
  "withdrawalSrcTimelock": 300,
  "publicWithdrawalSrcTimelock": 600,
  "cancellationSrcTimelock": 900,
  "publicCancellationSrcTimelock": 1200,
  "withdrawalDstTimelock": 300,
  "publicWithdrawalDstTimelock": 600,
  "cancellationDstTimelock": 900,
  "secret": "secret1",
  "stages": [
    "deployMocks",                  // stage for deployment mock resolver, src and dst tokens (only for chainId == 31337)
    // Eliminate any stages from the remaining list that are not required
    "deployEscrowSrc",              // fill order by resolver (deploy escrow contract on source chain)
    "deployEscrowDst",              // deploy escrow on destination chain 
    "withdrawSrc",                  // withdraw tokens on source chain
    "withdrawDst",                  // withdraw tokens on destination chain
    "cancelSrc",                    // cancel order on source chain
    "cancelDst"                     // cancel order on destination chain
  ],
  "rpcUrl": "https://your-mainnet-rpc-url",
  "chainId": 31337
}
```

## Usage

1. **Make the script executable:**
   ```zsh
   chmod +x create_order.sh
   ```

2. **Run the script:**
   ```zsh
   ./create_order.sh
   ```

   The script will:
   - Read your config and stages
   - Start Anvil with rpcUrl fork if `chainId` is 31337
   - Sequentially run each stage (deploy, withdraw, cancel, etc.)
   - For time-dependent stages, set the next block timestamp according to your config if `chainId` is 31337
   - Kill Anvil after all stages are complete if `chainId` is 31337

## Notes

- If you use a public RPC endpoint, ensure it is reliable and not rate-limited.
- You can customize the `stages` array in your config to run only specific steps.
- All logs and errors will be shown in your terminal. Check `anvil.log` for Anvil output.

## Troubleshooting

For more details, see the comments in `create_order.sh` or contact the project maintainers.
