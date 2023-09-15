#!/usr/bin/env bash

set -eux

whoami
id

# Uncomment this if docker file is not built yet.
# TODO, put if statement here.
#docker build --file ./deploy/docker/Dockerfile-build-linux -t qgc-linux-docker .

mkdir -p build
mkdir -p "${HOME}/.ccache_qgroundcontrol"

cd ${WORKSPACE}

usr="--user $(id -u):$(id -g)"

docker run --rm ${usr} \
-v ${PWD}:/project/source \
-v ${PWD}/build:/project/build \
-v "${HOME}/.ccache_qgroundcontrol":"${HOME}/.ccache" \
-v /etc/passwd:/etc/passwd:ro \
-v /etc/shadow:/etc/shadow:ro \
-v /etc/group:/etc/group:ro \
qgc-linux-docker

cd ${WORKSPACE}/build
../deploy/create_linux_appimage.sh ../ ./staging
