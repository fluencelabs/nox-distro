#!/usr/bin/env bash
set -o pipefail -o errexit -o nounset

jq -r '.url, .sha256, .version' fluence.json |
    while
        IFS=''
        read -r url
        read -r sha256
        read -r version
    do
        echo "*** download $version ***"
        # TODO: use --fail-with-body
        curl -sL --fail $url -o /fluence || (
            echo "failed to download $url" >&2
            exit 1
        )
        echo "$sha256 /fluence" | sha256sum --check --status || (
            echo "incorrect SHA256" >&2
            exit 1
        )
        chmod +x /fluence
    done
