#!/usr/bin/env bash
set -o pipefail -o errexit -o nounset

if [ "$#" -ne 1 ]; then
    echo "$0 expects a single argument: URL of services.json" >&1
    exit 1
fi

BUILTINS_DIR=./builtins/
TMP_BUILTINS=./tmp/builtins

mkdir -p $BUILTINS_DIR
mkdir -p $TMP_BUILTINS

echo "*** download services.json ***"
curl -sL "$1" -o services.json

jq -r '
    to_entries | .[] | .key, .value.url, .value.sha256, .value.version
' services.json |
    while
        read -r name
        read -r url
        read -r sha256
        read -r version
    do
        echo "*** download $name@$version ***"
        TAR="$TMP_BUILTINS/${name}.tar.gz"
        curl -sL $url -o $TAR
        echo "$sha256 $TAR" | sha256sum --check --status || (
            echo "incorrect SHA256 for $name" >&1
            exit 1
        )
        tar -C $BUILTINS_DIR -xf $TAR
    done

rm -rf $TMP_BUILTINS
