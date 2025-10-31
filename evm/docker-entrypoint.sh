#!/usr/bin/env bash
set -euo pipefail

if [[ "${NETWORK}" == "ghostnet" ]]; then
    NETWORK="testnet"
fi

__rollup_flag="--dont-track-rollup-node"
if [[ "${EVM_ONLY}" != "true" ]]; then
    __rollup_flag="--rollup-node-endpoint ${ROLLUP_NODE_URL}"
fi

# Initialize
if [[ ! -f /data/config.json ]]; then
    octez-evm-node init config --network "${NETWORK}" \
        --data-dir /data "${__rollup_flag}"
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
        --network "${NETWORK}" \
        --rpc-addr 0.0.0.0 \
        --rpc-batch-limit unlimited \
        --history full:1 \
        --init-from-snapshot \
        --ws \
        "${__rollup_flag}"
else
    exec octez-evm-node run observer \
        --data-dir /data \
        --network "${NETWORK}" \
        --rpc-addr 0.0.0.0 \
        --rpc-batch-limit unlimited \
        --history full:1 \
        --ws \
        "${__rollup_flag}"
fi
