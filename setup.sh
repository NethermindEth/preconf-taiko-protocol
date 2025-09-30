#!/bin/sh
set -e

. ./const.sh

./checksum.sh

# Env vars
: "${DEVNET_CHAIN_ID:?Need to set DEVNET_CHAIN_ID}"
: "${DEVNET_BEACON_GENESIS:?Need to set DEVNET_BEACON_GENESIS}"
: "${DEVNET_SECONDS_IN_SLOT:?Need to set DEVNET_SECONDS_IN_SLOT}"
: "${DEVNET_OP_CHANGE_DELAY:?Need to set DEVNET_OP_CHANGE_DELAY}"
: "${DEVNET_RANDOMNESS_DELAY:?Need to set DEVNET_RANDOMNESS_DELAY}"

# --- Patch genesis timestamp ---
sed -i "/uint256 internal constant ETHEREUM_HOODI_BEACON_GENESIS/a\\
    uint256 internal constant DEVNET_CHAIN_ID = ${DEVNET_CHAIN_ID};\\
    uint256 internal constant DEVNET_BEACON_GENESIS = ${DEVNET_BEACON_GENESIS};" "$PRECONF_FILE"

sed -i "/return ETHEREUM_HOODI_BEACON_GENESIS;/a\\
        } else if (_chainid == DEVNET_CHAIN_ID) {\\
            return DEVNET_BEACON_GENESIS;" "$PRECONF_FILE"

# --- Patch slot duration
sed -i "s|^[[:space:]]*uint256 internal constant SECONDS_IN_SLOT = 12;|    uint256 internal constant SECONDS_IN_SLOT = ${DEVNET_SECONDS_IN_SLOT};|" "$PRECONF_FILE"

sed -i "s|^[[:space:]]*uint256 internal constant ETHEREUM_BLOCK_TIME = 12 seconds;|    uint256 internal constant ETHEREUM_BLOCK_TIME = ${DEVNET_SECONDS_IN_SLOT} seconds;|" "$NETWORK_FILE"

# --- Patch deploy script to set Whitelist's operatorChangeDelay and randomnessDelay
sed -i "s|^[[:space:]]*data: abi.encodeCall(PreconfWhitelist.init, (owner, 2, 2))|    data: abi.encodeCall(PreconfWhitelist.init, (owner, ${DEVNET_OP_CHANGE_DELAY}, ${DEVNET_RANDOMNESS_DELAY}))|" "$DEPLOYMENT_SCRIPT_FILE"

echo "✅ Patched with DEVNET constants."