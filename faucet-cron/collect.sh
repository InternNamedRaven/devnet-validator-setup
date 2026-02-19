#!/bin/bash
# Devnet SOL Faucet Collector - Multi-source
# Collects from multiple faucets on schedule

WALLET="3HXud2gxAZZ6QX3vC46mPkWJ6RipqJWvBWp1TE1wocTa"
LOG_FILE="$HOME/.config/solana/faucet-cron/collection.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] === Faucet Collection Started ===" >> "$LOG_FILE"

# Track total collected
COLLECTED=0

# Helper function for airdrop requests
request_airdrop() {
    local name=$1
    local rpc=$2
    local amount=$3
    
    echo "[$DATE] [$name] Requesting ${amount} SOL..." >> "$LOG_FILE"
    RESPONSE=$(curl -s -X POST "$rpc" \
        -H "Content-Type: application/json" \
        -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"requestAirdrop\",\"params\":[\"$WALLET\",$((amount * 1000000000))]}" 2>&1)
    
    if echo "$RESPONSE" | grep -q "result"; then
        echo "[$DATE] [$name] ✓ Success: $RESPONSE" >> "$LOG_FILE"
        COLLECTED=$((COLLECTED + amount))
    else
        echo "[$DATE] [$name] ✗ Failed: $RESPONSE" >> "$LOG_FILE"
    fi
    sleep 3
}

# 1. Official Devnet RPC
request_airdrop "Official-1" "https://api.devnet.solana.com" 2
request_airdrop "Official-2" "https://api.devnet.solana.com" 2
request_airdrop "Official-3" "https://api.devnet.solana.com" 1

# 2. QuickNode Faucet (web-based, requires manual) - skip for now

# Check final balance
echo "[$DATE] Checking final balance..." >> "$LOG_FILE"
BALANCE=$(curl -s -X POST https://api.devnet.solana.com \
    -H "Content-Type: application/json" \
    -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"getBalance\",\"params\":[\"$WALLET\"]}")
echo "[$DATE] Balance response: $BALANCE" >> "$LOG_FILE"

# Extract balance in SOL
LAMPORTS=$(echo "$BALANCE" | grep -o '"value":[0-9]*' | cut -d: -f2)
if [ -n "$LAMPORTS" ]; then
    SOL=$(echo "scale=4; $LAMPORTS / 1000000000" | bc 2>/dev/null || echo "$((LAMPORTS / 1000000000)).$((LAMPORTS % 1000000000 / 1000000))")
    echo "[$DATE] Current Balance: ${SOL} SOL" >> "$LOG_FILE"
fi

echo "[$DATE] Total attempted: 5 SOL | Actually collected: ${COLLECTED} SOL" >> "$LOG_FILE"
echo "[$DATE] === Collection Complete ===" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
