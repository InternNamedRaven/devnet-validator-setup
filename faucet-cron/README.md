# Devnet SOL Faucet Cron

Automated collection of devnet SOL from multiple sources.

## Setup

Cron job runs daily at 9 AM:
```
0 9 * * * /bin/bash /home/agentraven/.config/solana/faucet-cron/collect.sh
```

## Faucets Used

1. **Official Solana Devnet RPC** - 5 SOL/day limit
2. Additional faucets to be added (QuickNode, etc.)

## Logs

View collection history:
```bash
tail -f ~/.config/solana/faucet-cron/collection.log
```

## Wallet

`3HXud2gxAZZ6QX3vC46mPkWJ6RipqJWvBWp1TE1wocTa`
