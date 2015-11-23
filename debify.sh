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
CACHE_ROOT=/tmp
KIBANA_VERSION=${1:-4.2.1}

log "Downloading kibana ${KIBANA_VERSION}"

KIBANA_NAME=kibana-${KIBANA_VERSION}-linux-x64

KIBANA_URL=https://download.elastic.co/kibana/kibana/${KIBANA_NAME}.tar.gz


curl -L ${KIBANA_URL} -O
mv  *.tar.gz tmp/

cd tmp/

log "Unpacking"

tar xvfz ${KIBANA_NAME}.tar.gz
mv ${KIBANA_NAME} kibana
cd kibana

log "Preparing the package"
echo "web: ./bin/kibana" > Procfile

log "Packaging!"
pkgr package . \
  --user=deploy \
  --group=deploy \
  --runner=upstart-1.5 \
  --version="${KIBANA_VERSION}" \
   --buildpack=git@github.com:ph3nx/heroku-binary-buildpack.git \
  --compile-cache-dir=${CACHE_ROOT}/compile \
  --buildpacks-cache-dir=${CACHE_ROOT}/build

log "Packaging done!"

mv -v *.deb ${ROOT}/

cd ${ROOT}

log "Here's your package"
ls *.deb

log "Done. Goodbye"
