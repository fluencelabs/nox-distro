ARG IPFS_VERSION=0.13.1
ARG CERAMIC_VERSION=2.3.x
ARG GLAZED_VERSION=0.2.x
ARG GETH_VERSION=1.10
ARG BITCOIN_CLI_VERSION=23.0

# prepare stage images
# ----------------------------------------------------------------------------
FROM ethereum/client-go:release-${GETH_VERSION} as prepare-geth
FROM ipfs/go-ipfs:v${IPFS_VERSION} as prepare-ipfs

FROM alpine as prepare-bitcoin
ARG BITCOIN_CLI_VERSION
# Download checksums
ADD https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_CLI_VERSION}/SHA256SUMS ./
# Download archive
ADD https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_CLI_VERSION}/bitcoin-${BITCOIN_CLI_VERSION}-x86_64-linux-gnu.tar.gz ./
# Verify that downloaded archive matches exactly the hash that's provided
RUN grep " bitcoin-${BITCOIN_CLI_VERSION}-x86_64-linux-gnu.tar.gz\$" SHA256SUMS | sha256sum -c -
# Extract
RUN tar -xzf "bitcoin-${BITCOIN_CLI_VERSION}-x86_64-linux-gnu.tar.gz"

# minimal
# ----------------------------------------------------------------------------
FROM ghcr.io/linuxserver/baseimage-ubuntu:jammy as minimal

# https://github.com/opencontainers/image-spec/blob/main/annotations.md#pre-defined-annotation-keys
LABEL org.opencontainers.image.base.name="ghcr.io/linuxserver/baseimage-ubuntu:focal"
LABEL org.opencontainers.image.url="https://github.com/fluencelabs/node-distro"
LABEL org.opencontainers.image.vendor="fluencelabs"
LABEL maintainer="fluencelabs"
LABEL org.opencontainers.image.authors="fluencelabs"
LABEL org.opencontainers.image.title="Fluence Node"
LABEL org.opencontainers.image.description="Minimal image containing only Fluence Node itself"

ENV RUST_LOG="info,aquamarine=warn,tokio_threadpool=info,tokio_reactor=info,mio=info,tokio_io=info,soketto=info,yamux=info,multistream_select=info,libp2p_secio=info,libp2p_websocket::framed=info,libp2p_ping=info,libp2p_core::upgrade::apply=info,libp2p_kad::kbucket=info,cranelift_codegen=info,wasmer_wasi=info,cranelift_codegen=info,wasmer_wasi=info"
ENV RUST_BACKTRACE="1"
## set /run_fluence as the CMD binary
ENV S6_CMD_ARG0="/run_fluence"

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  	jq \
  	less \
  	logrotate \
  	curl wget && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
  	/tmp/* \
  	/var/lib/apt/lists/* \
  	/var/tmp/*

# install missing libssl
RUN \
  wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb \
  && dpkg -i libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb \
  && rm libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb

# aqua-ipfs builtin default env variables
# instruct aqua-ipfs (client) to work with an IPFS node hosted on ipfs.fluence.dev
ENV FLUENCE_ENV_AQUA_IPFS_EXTERNAL_API_MULTIADDR=/dns4/ipfs.fluence.dev/tcp/5001
ENV FLUENCE_ENV_AQUA_IPFS_LOCAL_API_MULTIADDR=/dns4/ipfs.fluence.dev/tcp/5001

# download fluence, builtins
RUN --mount=type=bind,source=fluence,target=/fluence /fluence/download_builtins.sh /fluence/services.json
RUN --mount=type=bind,source=fluence,target=/fluence /fluence/download_fluence.sh /fluence/fluence.json

# copy default fluence config
COPY fluence/Config.default.toml /.fluence/v1/Config.toml

# copy IPFS binary
COPY --from=prepare-ipfs /usr/local/bin/ipfs /usr/bin/ipfs

# copy s6 configs
COPY s6/minimal/ /

# ipfs
# ----------------------------------------------------------------------------
FROM minimal as ipfs

LABEL org.opencontainers.image.description="Fluence Node bundled with IPFS daemon"
LABEL dev.fluence.bundles.ipfs="${IPFS_VERSION}"

ENV IPFS_PATH=/config/ipfs
ENV IPFS_LOG_DIR=/log/ipfs
ENV IPFS_LOGGING_FMT=nocolor
ENV IPFS_MIGRATE_FS=false
ENV IPFS_ADDRESSES_SWARM=/ip4/0.0.0.0/tcp/4001,/ip4/0.0.0.0/tcp/4001/ws
ENV IPFS_ADDRESSES_API=/ip4/0.0.0.0/tcp/5001
ENV IPFS_ADDRESSES_GATEWAY=/ip4/0.0.0.0/tcp/8080
ENV IPFS_ADDRESSES_ANNOUNCE=/ip4/127.0.0.1/tcp/4001,/ip4/127.0.0.1/tcp/4001/ws

# aqua-ipfs builtin default env variables
# instruct aqua-ipfs (client) to work with an IPFS node hosted on 127.0.0.1 (inside this docker container)
ENV FLUENCE_ENV_AQUA_IPFS_EXTERNAL_API_MULTIADDR=/ip4/127.0.0.1/tcp/5001
ENV FLUENCE_ENV_AQUA_IPFS_LOCAL_API_MULTIADDR=/ip4/127.0.0.1/tcp/5001

# download fs-repo-migrations
RUN wget -qO - "https://dist.ipfs.io/fs-repo-migrations/v2.0.2/fs-repo-migrations_v2.0.2_linux-amd64.tar.gz" | tar -C /usr/local/bin --strip-components=1 -zxvf -

# copy s6 configs
COPY s6/ipfs/ /

# expose IPFS node port
EXPOSE 5001

# rich
# ----------------------------------------------------------------------------
FROM ipfs as rich
ARG CERAMIC_VERSION
ARG GLAZED_VERSION
ARG GETH_VERSION
ARG BITCOIN_CLI_VERSION

LABEL org.opencontainers.image.description="Fluence Node bundled with IPFS, Ceramic CLI and other tools"
LABEL dev.fluence.image.bundles.ceramic="${CERAMIC_VERSION}"
LABEL dev.fluence.image.bundles.glazed="${GLAZED_VERSION}"
LABEL dev.fluence.image.bundles.bitcoin_cli="${BITCOIN_CLI_VERSION}"
LABEL dev.fluence.image.bundles.geth="${GETH_VERSION}"

# add nodejs 16.x repo
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor > /usr/share/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x focal main" > /etc/apt/sources.list.d/nodesource.list

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    musl \
    nodejs && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# install ceramic and glaze
RUN npm install --cache /cache --global \
  @ceramicnetwork/cli@$CERAMIC_VERSION \
  @glazed/cli@$GLAZED_VERSION \
  && rm -rf /cache

# copy geth
COPY --from=prepare-geth /usr/local/bin/geth /usr/bin/geth

# copy bitcoin-cli
COPY --from=prepare-bitcoin /bitcoin-${BITCOIN_CLI_VERSION}/bin/bitcoin-cli /usr/bin/bitcoin-cli

# copy s6 configs
COPY s6/rich/ /
