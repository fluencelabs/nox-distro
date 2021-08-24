### NOTE: original linuxserver.org docker-ipfs image also builds & runs migrations.
###		  If needed, go to https://github.com/linuxserver/docker-ipfs to see how it's done.

ARG FLUENCE_TAG=latest
FROM fluencelabs/fluence:${FLUENCE_TAG} as fluence

FROM ipfs/go-ipfs:v0.9.0 as ipfs

FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

# TODO:
# - set version
# - set build date

# environment
ENV IPFS_PATH=/config/ipfs
ENV IPFS_LOGGING_FMT=nocolor
ENV RUST_LOG="info,aquamarine=warn,tokio_threadpool=info,tokio_reactor=info,mio=info,tokio_io=info,soketto=info,yamux=info,multistream_select=info,libp2p_secio=info,libp2p_websocket::framed=info,libp2p_ping=info,libp2p_core::upgrade::apply=info,libp2p_kad::kbucket=info,cranelift_codegen=info,wasmer_wasi=info,cranelift_codegen=info,wasmer_wasi=info"
ENV RUST_BACKTRACE="1"
## set /fluence as the CMD binary
ENV S6_CMD_ARG0="/run_fluence"

# fluence builtins default envs
ENV FLUENCE_ENV_IPFS_ADAPTER_EXTERNAL_API_MULTIADDR=/ip4/127.0.0.1/tcp/5001
ENV FLUENCE_ENV_IPFS_ADAPTER_LOCAL_API_MULTIADDR=/ip4/127.0.0.1/tcp/5001
ENV FLUENCE_ENV_IPFS_ADAPTER_EXTERNAL_SWARM_MULTIADDR=/ip4/127.0.0.1/tcp/4001

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
	less \
	logrotate \
	curl && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/* && \
echo "**** download ipfs-adapter ****" && \
mkdir -p /builtins/ && \
curl https://github.com/fluencelabs/aqua-ipfs/releases/download/v0.3.4/ipfs-adapter.tar.gz -L | tar -zxv -C /builtins/

# copy fluence
# TODO: copy binary to /usr/bin & state to /config/fluence
COPY --from=fluence /fluence /fluence
COPY --from=fluence /.fluence /.fluence
COPY --from=fluence /builtins /builtins

# copy sidecars
COPY --from=ipfs /usr/local/bin/ipfs /usr/bin/ipfs

# copy configs
# NOTE: copy configs should be after installing packages because
# 		configs may replace default configs of installed packages
COPY s6/root/ /

COPY run_fluence /run_fluence

# ports and volumes
EXPOSE 5001
VOLUME ["/config"]
VOLUME ["/.fluence"]
