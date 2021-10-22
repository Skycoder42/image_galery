#!/bin/bash
set -ex

ARCH=$(uname -m)
export LIBSEARPC_VERSION=3.2-latest
export SEAFILE_VERSION=8.0.4

sudo docker build \
  --force-rm \
  --pull \
  --build-arg LIBSEARPC_VERSION=$LIBSEARPC_VERSION \
  --build-arg SEAFILE_VERSION=$SEAFILE_VERSION \
  --tag skycoder42/seafile-client:$ARCH-latest \
  --tag skycoder42/seafile-client:$ARCH-$SEAFILE_VERSION \
  seafile
