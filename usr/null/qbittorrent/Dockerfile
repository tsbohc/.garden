# https://github.com/qbittorrent/qBittorrent/wiki/Compilation:-Alpine-Linux
FROM docker.io/alpine AS builder

# build and app deps
RUN apk add --update --no-cache \
    autoconf samurai automake build-base boost-dev cmake git libtool linux-headers perl pkgconf python3 python3-dev re2c tar \
    icu-dev libexecinfo-dev openssl-dev qt5-qtbase-dev qt5-qttools-dev zlib-dev qt5-qtsvg-dev

WORKDIR /tmp

# libtorrent build
RUN git clone --shallow-submodules --recurse-submodules https://github.com/arvidn/libtorrent.git \
  && cd libtorrent \
  && git checkout "$(git tag -l --sort=-v:refname "v1*" | head -n 1)" \
  && cmake -Wno-dev -G Ninja -B build \
           -D CMAKE_BUILD_TYPE="Release" \
           -D CMAKE_CXX_STANDARD=17 \
           -D CMAKE_INSTALL_LIBDIR="lib" \
           -D CMAKE_INSTALL_PREFIX="/usr/local" \
  && cmake --build build \
  && cmake --install build

# qbittorrent build
RUN git clone --shallow-submodules --recurse-submodules https://github.com/qbittorrent/qBittorrent.git \
  && cd qBittorrent \
  && git checkout "$(git tag -l --sort=-v:refname | head -n 1)" \
  && cmake -Wno-dev -G Ninja -B build \
           -D GUI=OFF \
           -D CMAKE_BUILD_TYPE="release" \
           -D CMAKE_CXX_STANDARD=17 \
           -D CMAKE_CXX_STANDARD_LIBRARIES="/usr/lib/libexecinfo.so" \
           -D CMAKE_INSTALL_PREFIX="/usr/local" \
  && cmake --build build \
  && cmake --install build

# ---

FROM docker.io/alpine

COPY --from=builder /usr/local/bin/qbittorrent-nox /usr/bin/qbittorrent-nox
COPY --from=builder /usr/local/lib/libtorrent-rasterbar.so /usr/lib/libtorrent-rasterbar.so.10

RUN apk add --update --no-cache \
    qt5-qtbase \
    libexecinfo \
    unzip \
    curl

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

EXPOSE 8080

WORKDIR /data
VOLUME /data

#RUN curl -L https://github.com/WDaan/VueTorrent/releases/latest/download/vuetorrent.zip \
#    -o vuetorrent.zip \
#  && unzip vuetorrent.zip \
#  && rm -f vuetorrent.zip \
#  && mv vuetorrent webui

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/qbittorrent-nox"]

HEALTHCHECK --interval=1m --timeout=10s --start-period=30s \
  CMD curl --fail http://127.0.0.1:8080/api/v2/app/version || exit 1
