#!/usr/bin/env bash
set -euo pipefail

ADDRESS="sr1Ghq66tYK9y3r8CC1Tf8i8m5nxh8nTvZEf"
URL=https://snapshots.tzinit.org/etherlink-mainnet/wasm_2_0_0

if [[ "$NETWORK" == "testnet" ]]; then
    ADDRESS="sr18wx6ezkeRjt1SZSeZ2UQzQN3Uc3YLMLqg"
    URL=https://snapshots.tzinit.org/etherlink-ghostnet/wasm_2_0_0
fi

if [[ ! -f /data/config.json ]]; then
    octez-smart-rollup-node init observer config for "$ADDRESS" with operators --data-dir /data --pre-images-endpoint "$URL"
fi

# octez-smart-rollup-node --endpoint https://rpc.tzkt.io/mainnet \
#   snapshot import eth-mainnet.full \
#   --data-dir <SR_DATA_DIR>

# octez-smart-rollup-node --endpoint https://rpc.tzkt.io/ghostnet \
#   snapshot import eth-ghostnet.full \
#   --data-dir $SR_DATA_DIR
