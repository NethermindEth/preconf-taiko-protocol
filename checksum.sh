#!/bin/sh
set -e

. ./const.sh

check_checksum() {
    local file=$1
    local expected_sha=$2

    current_sha=$(sha256sum "$file" | awk '{print $1}')
    if [ "$current_sha" != "$expected_sha" ]; then
        echo "❌ Checksum mismatch for $file. Aborting. Current checksum $current_sha"
        exit 1
    fi
}

# Check all files
check_checksum "$PRECONF_FILE" "$PRECONF_FILE_SHA"
check_checksum "$NETWORK_FILE" "$NETWORK_FILE_SHA"

echo "✅ Checksum matches. Safe to patch."