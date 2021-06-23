### NOTE: original linuxserver.org docker-ipfs image also builds & runs migrations.
###		  If needed, go to https://github.com/linuxserver/docker-ipfs to see how it's done.
 
FROM ipfs/go-ipfs:v0.9.0 as ipfs

FROM fluencelabs/fluence:latest as fluence

FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

# TODO:
# - set version
# - set build date

# environment
ENV IPFS_PATH=/config/ipfs
ENV RUST_LOG="info,aquamarine=warn,tokio_threadpool=info,tokio_reactor=info,mio=info,tokio_io=info,soketto=info,yamux=info,multistream_select=info,libp2p_secio=info,libp2p_websocket::framed=info,libp2p_ping=info,libp2p_core::upgrade::apply=info,libp2p_kad::kbucket=info,cranelift_codegen=info,wasmer_wasi=info,cranelift_codegen=info,wasmer_wasi=info"
ENV RUST_BACKTRACE="1"
## set /fluence as the CMD binary
ENV S6_CMD_ARG0="/fluence"

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
	logrotate \
	curl && \
 echo "**** fix logrotate ****" && \
 sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
 sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' \
	/etc/periodic/daily/logrotate && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# copy files
COPY s6/root/ /
COPY --from=ipfs /usr/local/bin/ipfs /usr/bin/ipfs
# TODO: copy binary to /usr/bin & state to /config/fluence
COPY --from=fluence /fluence /fluence
COPY --from=fluence /.fluence /.fluence
COPY --from=fluence /builtins /builtins

# ports and volumes
EXPOSE 5001
VOLUME ["/config"]
VOLUME ["/fluence"]