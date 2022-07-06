ARG COMMIT
ARG SERVICES_VERSION
ARG RUN_NUMBER
ARG TAG
ARG BUILD_DATE

ARG IPFS=v0.9.0
ARG CERAMIC_VERSION=2.3.x
ARG GLAZED_VERSION=0.2.x

# fluence base image
FROM ghcr.io/linuxserver/baseimage-ubuntu:focal as fluence

# https://github.com/opencontainers/image-spec/blob/main/annotations.md#pre-defined-annotation-keys
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${RUN_NUMBER}"
LABEL org.opencontainers.image.base.name="ghcr.io/linuxserver/baseimage-ubuntu:focal"
LABEL org.opencontainers.image.url="https://github.com/fluencelabs/node-distro"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.vendor="fluencelabs"
LABEL org.opencontainers.image.title="Fluence Node"
LABEL org.opencontainers.image.discription="Base image containing only Fluence Node itself"

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
	curl && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# download fluence & builtin services
RUN --mount=type=bind,source=fluence,target=/fluence /fluence/download_fluence.sh /fluence/fluence.json
RUN --mount=type=bind,source=fluence,target=/fluence /fluence/download_builtins.sh /fluence/services.json

# copy default fluence config
COPY fluence/Config.default.toml /.fluence/v1/Config.toml

# copy s6 configs
# NOTE: copy configs should be after installing packages because
# 		configs may replace default configs of installed packages
COPY s6/fluence/ /

EXPOSE 5001

# fluence-ipfs image
### NOTE: original linuxserver.org docker-ipfs image also builds & runs migrations.
###		  If needed, go to https://github.com/linuxserver/docker-ipfs to see how it's done.
FROM ipfs/go-ipfs:${IPFS} as ipfs

FROM fluence as fluence-ipfs

LABEL org.opencontainers.image.discription="Fluence Node bundled with IPFS ${IPFS}"

ENV IPFS_PATH=/ipfs IPFS_LOG_DIR=/ipfs/logs IPFS_LOGGING_FMT=nocolor

# fluence builtins default envs
ENV FLUENCE_ENV_AQUA_IPFS_EXTERNAL_API_MULTIADDR=/ip4/127.0.0.1/tcp/5001
ENV FLUENCE_ENV_AQUA_IPFS_LOCAL_API_MULTIADDR=/ip4/127.0.0.1/tcp/5001
ENV FLUENCE_ENV_AQUA_IPFS_EXTERNAL_SWARM_MULTIADDR=/ip4/127.0.0.1/tcp/4001

# copy IPFS binary
COPY --from=ipfs /usr/local/bin/ipfs /usr/bin/ipfs

# copy s6 configs
COPY s6/fluence-ipfs/ /

# fluence-bundle
FROM fluence-ipfs as fluence-bundle

LABEL org.opencontainers.image.discription="Fluence Node bundled with IPFS ${IPFS}, Ceramic CLI ${CERAMIC_VERSION} and Glazeda ${GLAZED_VERSION}"

# install nodejs 16.x
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor > /usr/share/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x focal main" > /etc/apt/sources.list.d/nodesource.list

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y --no-install-recommends \
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
