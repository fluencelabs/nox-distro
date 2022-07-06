#!/usr/bin/env bash
set -o pipefail -o errexit -o nounset

CONFIG="${1:-fluence.json}"

jq -r '.url, .sha256, .version' $CONFIG |
    while
        IFS=''
        read -r url
        read -r sha256
        read -r version
    do
        echo "*** download $version ***"
        # TODO: use --fail-with-body
        curl -sL --fail $url -o /usr/bin/fluence || (
            echo "failed to download $url" >&2
            exit 1
        )
        echo "$sha256 /usr/bin/fluence" | sha256sum --check --status || (
            echo "incorrect SHA256" >&2
            exit 1
        )
        chmod +x /usr/bin/fluence
    done
