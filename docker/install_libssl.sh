#! /usr/bin/env sh

case "$TARGETPLATFORM" in
'linux/amd64')
  URL="http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb"
  ;;
'linux/arm64')
  URL="http://launchpadlibrarian.net/668086110/libssl1.1_1.1.1-1ubuntu2.1~18.04.23_arm64.deb"
  ;;
esac

wget $URL -O libssl.deb
dpkg -i libssl.deb
rm libssl.deb
