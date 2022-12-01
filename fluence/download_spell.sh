#!/usr/bin/env bash
set -o pipefail -o errexit -o nounset

CONFIG="${1:-spell.json}"

SPELL_DIR=/spell/
TMP_SPELL=./tmp/spell

mkdir -p $SPELL_DIR
mkdir -p $TMP_SPELL

jq -r '
    to_entries | .[] | .key, .value.url, .value.sha256, .value.version
' $CONFIG |
    while
        read -r name
        read -r url
        read -r sha256
        read -r version
    do
        echo "*** download $name@$version ***"
        TAR="$TMP_SPELL/${name}.tar.gz"
        # TODO: use --fail-with-body
        curl -sL --fail $url -o $TAR || (
            echo "failed to download $url" >&2
            exit 1
        )
        echo "$sha256 $TAR" | sha256sum --check --status || (
            echo "incorrect SHA256 for $name" >&2
            exit 1
        )
        tar -C $SPELL_DIR -xf $TAR
    done

rm -rf $TMP_SPELL