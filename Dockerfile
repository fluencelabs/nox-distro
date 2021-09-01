### NOTE: original linuxserver.org docker-ipfs image also builds & runs migrations.
###		  If needed, go to https://github.com/linuxserver/docker-ipfs to see how it's done.

ARG IPFS=v0.9.0

FROM ipfs/go-ipfs:${IPFS} as ipfs

FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

ARG COMMIT
ARG SERVICES_VERSION
ARG RUN_NUMBER
ARG TAG
ARG BUILD_DATE
LABEL commit="${commit}"
LABEL build_version="Fluence Node version=${TAG} date=${BUILD_DATE} ci_run=${RUN_NUMBER} builtins=${SERVICES_VERSION} IPFS=${IPFS}"
LABEL maintainer="fluencelabs"

# environment
ENV IPFS_PATH=/config/ipfs
ENV IPFS_LOGGING_FMT=nocolor
ENV RUST_LOG="info,aquamarine=warn,tokio_threadpool=info,tokio_reactor=info,mio=info,tokio_io=info,soketto=info,yamux=info,multistream_select=info,libp2p_secio=info,libp2p_websocket::framed=info,libp2p_ping=info,libp2p_core::upgrade::apply=info,libp2p_kad::kbucket=info,cranelift_codegen=info,wasmer_wasi=info,cranelift_codegen=info,wasmer_wasi=info"
ENV RUST_BACKTRACE="1"
## set /fluence as the CMD binary
ENV S6_CMD_ARG0="/run_fluence"

# fluence builtins default envs
ENV FLUENCE_ENV_AQUA_IPFS_EXTERNAL_API_MULTIADDR=/ip4/127.0.0.1/tcp/5001
ENV FLUENCE_ENV_AQUA_IPFS_LOCAL_API_MULTIADDR=/ip4/127.0.0.1/tcp/5001
ENV FLUENCE_ENV_AQUA_IPFS_EXTERNAL_SWARM_MULTIADDR=/ip4/127.0.0.1/tcp/4001

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
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
COPY fluence/download_builtins.sh /download_builtins.sh
RUN /download_builtins.sh fluence/services.json

# TODO: copy binary to /usr/bin & state to /config/fluence
RUN /download_fluence.sh
COPY fluence/Config.default.toml /.fluence/v1/Config.toml

# copy sidecars
COPY --from=ipfs /usr/local/bin/ipfs /usr/bin/ipfs

# copy configs
# NOTE: copy configs should be after installing packages because
# 		configs may replace default configs of installed packages
COPY s6/root/ /

COPY fluence/run_fluence /run_fluence

# ports and volumes
EXPOSE 5001
VOLUME ["/config"]
VOLUME ["/.fluence"]
