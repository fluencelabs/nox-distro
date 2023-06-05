#! /usr/bin/env bash

case "$TARGETPLATFORM" in
  'linux/amd64')
    ARCHIVE="bitcoin-${BITCOIN_CLI_VERSION}-x86_64-linux-gnu.tar.gz" ;;
  'linux/arm64')
    ARCHIVE="bitcoin-${BITCOIN_CLI_VERSION}-aarch64-linux-gnu.tar.gz" ;;
esac

wget "https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_CLI_VERSION}/$ARCHIVE"
grep " $ARCHIVE\$" SHA256SUMS | sha256sum -c -
tar -xzf "$ARCHIVE"
rm "$ARCHIVE"
