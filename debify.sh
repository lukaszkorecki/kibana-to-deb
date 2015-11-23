#!/usr/bin/env bash


log() {
  logger -s -t DEBIFY -- "$*"
}

set -e

# cleanup
rm -rf ./tmp/*
mkdir -p ./tmp
rm -f *.tar.gz *.deb

ROOT=$(pwd)
KIBANA_VERSION=${1:-4.2.1}

log "Downloading kibana ${KIBANA_VERSION}"

KIBANA_NAME=kibana-${KIBANA_VERSION}-linux-x64

KIBANA_URL=https://download.elastic.co/kibana/kibana/${KIBANA_NAME}.tar.gz


curl -L ${KIBANA_VERSION} -O
mv  *.tar.gz tmp/

cd tmp/

log "Unpacking"

tar xvfz ${KIBANA_NAME}.tar.gz
cd ${KIBANA_NAME}

log "Preparing the package"
echo "web: ./bin/kibana" > Procfile

pkgr package . \
  --user=deploy \
  --group=deploy \
  --runner=upstart-1.5 \
  --version="$(cat VERSION)" \
   --buildpack=git@github.com:ph3nx/heroku-binary-buildpack.git \
  --compile-cache-dir=$cacheRoot/compile \
  --buildpacks-cache-dir=$cacheRoot/build

log "Packaging done!"

mv *.deb ${ROOT}/

ls *.deb
