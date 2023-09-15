#!/usr/bin/env bash

set +eux

whoami

# Uncomment this if docker file is not built yet.
# TODO, put if statement here.
#docker build --file ./deploy/docker/Dockerfile-build-linux -t qgc-linux-docker .

mkdir -p build
# sudo chown user:user build

# su - user <<!
# user
# whoami
cd ${WORKSPACE}

docker run --rm --user jenkins -v ${PWD}:/project/source -v ${PWD}/build:/project/build qgc-linux-docker

cd ${WORKSPACE}/build
../deploy/create_linux_appimage.sh ../ ./staging
