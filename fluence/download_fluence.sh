#!/usr/bin/env bash
set -o pipefail -o errexit -o nounset

# Validate necessary commands and given config file
for cmd in jq curl sha256sum; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd could not be found, please install it."
        exit
    fi
done

CONFIG="${1:-fluence.json}"

if [[ ! -f "$CONFIG" ]]; then
    echo "Config file $CONFIG not found!"
    exit 1
fi

# Detect system architecture
ARCHITECTURE=$(uname -m)

# Map common architecture names to the ones used in your JSON
case "$ARCHITECTURE" in
    x86_64)
        KEY="x86_64"
        ;;
    aarch64)
        KEY="aarch64"
        ;;
    *)
        echo "Unsupported architecture: $ARCHITECTURE. Exiting..."
        exit 1
        ;;
esac

# Fetch URL, SHA256, and version based on detected architecture
URL=$(jq -r ".${KEY}.url" $CONFIG)
SHA256=$(jq -r ".${KEY}.sha256" $CONFIG)
VERSION=$(jq -r ".${KEY}.version" $CONFIG)

echo "*** Downloading nox version $VERSION for $ARCHITECTURE ***"

ATTEMPTS=5
while ((ATTEMPTS)); do
    curl -sL --fail $URL -o /usr/bin/nox && break
    ((ATTEMPTS--))
    sleep 5
done

if ! ((ATTEMPTS)); then
    echo "Failed to download $URL after 5 attempts. Exiting..."
    cat "$CONFIG"
    exit 1
fi

if ! echo "$SHA256 /usr/bin/nox" | sha256sum --check --status; then
    echo "Incorrect SHA256 for the downloaded file. Exiting..."
    exit 1
fi

chmod +x /usr/bin/nox

echo "*** Successfully installed nox version $VERSION for $ARCHITECTURE ***"
