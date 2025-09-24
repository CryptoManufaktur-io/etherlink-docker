#!/usr/bin/env bash
set -euo pipefail

ADDRESS="sr1Ghq66tYK9y3r8CC1Tf8i8m5nxh8nTvZEf"

if [[ "${NETWORK}" == "ghostnet" ]]; then
    ADDRESS="sr18wx6ezkeRjt1SZSeZ2UQzQN3Uc3YLMLqg"
fi

# Initialize
if [[ ! -f /data/config.json ]]; then
    octez-smart-rollup-node init observer config for "$ADDRESS" \
      with operators --data-dir /data \
      --pre-images-endpoint "https://snapshots.tzinit.org/etherlink-${NETWORK}/wasm_2_0_0"
fi

# Download snapshot
if [ -n "${ROLLUP_SNAPSHOT:-}" ] && [ ! -d "/data/wasm_2_0_0" ]; then
    SNAP_FILE="${ROLLUP_SNAPSHOT_FILE:-snapshot}"
    echo "Downloading snapshot to $SNAP_FILE ..."
    if command -v aria2c >/dev/null 2>&1; then
        aria2c -c -x6 -s6 --auto-file-renaming=false --conditional-get=true --allow-overwrite=true -o "$SNAP_FILE" "${ROLLUP_SNAPSHOT}"
    else
        wget -O "$SNAP_FILE" "${ROLLUP_SNAPSHOT}"
    fi

    echo "Importing snapshot $SNAP_FILE ..."
    octez-smart-rollup-node --endpoint "https://rpc.tzkt.io/${NETWORK}" \
      snapshot import "$SNAP_FILE" \
      --data-dir /data
else
    echo "No snapshot fetch necessary"
fi

# Start node
exec octez-smart-rollup-node --endpoint "https://rpc.tzkt.io/${NETWORK}" run \
  --data-dir /data --history-mode full --metrics-addr 0.0.0.0:6060 \
  --rpc-addr 0.0.0.0 --mode observer
