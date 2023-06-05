#! /usr/bin/env bash

case "$TARGETPLATFORM" in
'linux/amd64')
  ARCHIVE="fs-repo-migrations_v2.0.2_linux-amd64.tar.gz"
  ;;
'linux/arm64')
  ARCHIVE="fs-repo-migrations_v2.0.2_linux-arm64.tar.gz"
  ;;
esac

wget -qO - "https://dist.ipfs.io/fs-repo-migrations/v2.0.2/$ARCHIVE" | tar -C /usr/local/bin --strip-components=1 -zxvf -
