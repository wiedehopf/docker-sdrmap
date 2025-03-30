# Note - do not remove the ##telegraf## tags from this file - they are used to build a tag that includes the telegraf binary
##telegraf##FROM telegraf:1.26 AS telegraf

##telegraf##RUN touch /tmp/emptyfile

FROM ghcr.io/sdr-enthusiasts/docker-baseimage:wreadsb

ENV BEASTPORT=30005 \
    SMUSERNAME=yourusername \
    SMPASSWORD=yourpassword \
    MLAT=false

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN set -x && \
    TEMP_PACKAGES=() && \
    KEPT_PACKAGES=() && \
    KEPT_PACKAGES+=(gzip) && \
    KEPT_PACKAGES+=(curl) && \
    KEPT_PACKAGES+=(stunnel4) && \
    # install packages
    apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends \
    "${KEPT_PACKAGES[@]}" \
    "${TEMP_PACKAGES[@]}" && \
    # Clean-up.
    apt-get autoremove -q -o APT::Autoremove::RecommendsImportant=0 -o APT::Autoremove::SuggestsImportant=0 -y "${TEMP_PACKAGES[@]}" && \
    apt-get clean -q -y && \
    bash /scripts/clean-build.sh && \
    rm -rf /src/* /tmp/* /var/lib/apt/lists/* /var/cache/*

COPY rootfs/ /
