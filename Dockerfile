### NOTE: original linuxserver.org docker-ipfs image also builds & runs migrations.
###		  If needed, go to https://github.com/linuxserver/docker-ipfs to see how it's done.
 
# FROM ipfs/go-ipfs:v0.9.0 as ipfs

FROM fluencelabs/fluence:latest as fluence

FROM bitnami/minideb:latest

# TODO:
# - set version
# - set build date

# environment
ENV IPFS_PATH=/config/ipfs

# download S6
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-x86.tar.gz /tmp/

RUN \
 echo "**** install S6 ****" && \
 gunzip -c /tmp/s6-overlay-x86.tar.gz | tar -xf - -C /

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
	/var/tmp/*

# copy files
COPY s6/root/ /
# COPY --from=ipfs /usr/local/bin/ipfs /usr/bin/ipfs

# ports and volumes
EXPOSE 5001
VOLUME ["/config"]

ENTRYPOINT ["/init"]