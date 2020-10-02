FROM alpine:latest as base
RUN apk add build-base git autoconf automake libtool python3 jansson-dev glib-dev

FROM base as python
RUN apk add py3-pip py3-wheel
RUN python3 -m pip install --prefix="/deploy/usr" future gobject simplejson

FROM base as libsearpc
ARG LIBSEARPC_VERSION
WORKDIR /build
RUN git clone https://github.com/haiwen/libsearpc.git --branch v$LIBSEARPC_VERSION --depth 1 .
RUN sh ./autogen.sh
RUN sh ./configure -prefix=/usr
RUN make
RUN make check
RUN make DESTDIR=/deploy install

FROM base as seafile
ARG SEAFILE_VERSION
RUN apk add vala sqlite-dev libevent-dev curl-dev
COPY --from=libsearpc /deploy /
WORKDIR /build
RUN git clone https://github.com/haiwen/seafile.git --branch v$SEAFILE_VERSION --depth 1 .
RUN sh ./autogen.sh
RUN sh ./configure -prefix=/usr
RUN make
RUN make DESTDIR=/deploy install

FROM alpine:latest
RUN apk add --no-cache python3 sqlite-libs jansson libevent libcurl libuuid glib
COPY --from=python /deploy /
COPY --from=libsearpc /deploy /
COPY --from=seafile /deploy /
RUN mkdir -p /seafile
RUN seaf-cli init -d /seafile
ENTRYPOINT ["seaf-daemon", "-c", "/root/.ccnet", "-d", "/seafile/seafile-data", "-w", "/seafile/seafile"]
