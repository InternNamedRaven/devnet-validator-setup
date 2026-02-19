#!/bin/bash
# Devnet validator startup script

export PATH="/home/agentraven/.local/share/solana/install/active_release/bin:$PATH"

echo "Starting devnet validator..."
echo "Identity: 8ZsesCoWZDc932A9EpDLE9qWz41KxYGSNisLaTGwV5TV"
echo "Vote Account: AFajpxVv6aagBEfYPhJoJUXZwwJXBPiL6Xtq1Z8aEvLa"

exec agave-validator \
  --identity ~/.config/solana/validator/validator-keypair.json \
  --vote-account ~/.config/solana/validator/vote-account-keypair.json \
  --rpc-port 8899 \
  --entrypoint entrypoint.devnet.solana.com:8001 \
  --limit-ledger-size 50000000 \
  --log ~/.config/solana/validator/validator.log \
  --enable-rpc-transaction-history \
  --enable-cpi-and-log-storage
