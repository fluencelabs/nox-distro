#!/usr/bin/env bash
set -o pipefail -o errexit -o nounset

BUILTINS_DIR=/builtins/
TMP_BUILTINS=./tmp/builtins

mkdir -p $BUILTINS_DIR
mkdir -p $TMP_BUILTINS

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
        # TODO: use --fail-with-body
        curl -sL --fail $url -o $TAR || (
            echo "failed to download $url" >&2
            exit 1
        )
        echo "$sha256 $TAR" | sha256sum --check --status || (
            echo "incorrect SHA256 for $name" >&2
            exit 1
        )
        tar -C $BUILTINS_DIR -xf $TAR
    done

rm -rf $TMP_BUILTINS
