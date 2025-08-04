#!/usr/bin/env bash
set -euo pipefail

if [[ "${NETWORK}" == "ghostnet" ]]; then
    NETWORK="testnet"
fi

# Initialize
if [[ ! -f /data/config.json ]]; then
    octez-evm-node init config --network "${NETWORK}" \
        --data-dir /data --rollup-node-endpoint http://rollup:8932
fi

# Remove experimental section, websockets now enabled via --ws
tmpfile=$(mktemp)
jq 'del(.experimental_features)' /data/config.json > "$tmpfile"
if ! cmp -s "$tmpfile" /data/config.json; then
  mv "$tmpfile" /data/config.json
else
  rm "$tmpfile"
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
        --init-from-snapshot \
        --ws
else
    exec octez-evm-node run observer \
        --data-dir /data \
        --rollup-node-endpoint http://rollup:8932 \
        --network "${NETWORK}" \
        --rpc-addr 0.0.0.0 \
        --rpc-batch-limit unlimited \
        --history full:1 \
        --ws
fi
