#!/usr/bin/env bash
set -euo pipefail

if [[ "${NETWORK}" == "ghostnet" ]]; then
    NETWORK="testnet"
fi

# Initialize
if [[ ! -f /data/config.json ]]; then
    octez-evm-node init config --network "${NETWORK}" \
        --data-dir /data --rollup-node-endpoint http://rollup:8932

    # Enable websockets
    jq 'if has("experimental_features") then . else . + {
        "experimental_features": {
            "enable_websocket": true
        }} end' /data/config.json > /data/config.updated.json
    mv /data/config.updated.json /data/config.json
fi

# Start node
if [ ! -d "/data/wasm_2_0_0" ]; then
    exec octez-evm-node run observer \
        --data-dir /data \
        --rollup-node-endpoint http://rollup:8932 \
        --network "${NETWORK}" \
        --rpc-addr 0.0.0.0 \
        --rpc-batch-limit unlimited \
        --history full:1 \
        --init-from-snapshot
else
    exec octez-evm-node run observer \
        --data-dir /data \
        --rollup-node-endpoint http://rollup:8932 \
        --network "${NETWORK}" \
        --rpc-addr 0.0.0.0 \
        --rpc-batch-limit unlimited \
        --history full:1
fi
