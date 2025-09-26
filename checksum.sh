#!/bin/sh
set -e

. ./const.sh

CURRENT_CHECKSUM=$(sha256sum "$PRECONF_FILE" | awk '{print $1}')

if [ "$CURRENT_CHECKSUM" != "$PRECONF_FILE_SHA" ]; then
    echo "❌ Checksum mismatch for $PRECONF_FILE. Aborting. Current checksum $CURRENT_CHECKSUM"
    exit 1
fi

CURRENT_CHECKSUM=$(sha256sum "$NETWORK_FILE" | awk '{print $1}')

if [ "$CURRENT_CHECKSUM" != "$NETWORK_FILE_SHA" ]; then
    echo "❌ Checksum mismatch for $NETWORK_FILE. Aborting. Current checksum $CURRENT_CHECKSUM"
    exit 1
fi

echo "✅ Checksum matches. Safe to patch."