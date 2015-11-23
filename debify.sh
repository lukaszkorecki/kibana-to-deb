#!/usr/bin/env bash

set -e

ROOT=$(pwd)
KIBANA_VERSION=${1:-4.2.1}

KIBANA_NAME=kibana-${KIBANA_VERSION}-linux-x64

KIBANA_URL=https://download.elastic.co/kibana/kibana/${KIBANA_NAME}.tar.gz


mkdir -p ./tmp

rm *.tar.gz


curl -L ${KIBANA_VERSION} -O
mv  *.tar.gz tmp/

cd tmp/

tar xvfz ${KIBANA_NAME}.tar.gz
cd ${KIBANA_NAME}

echo "web: ./bin/kibana" > Procfile

pkgr package . \
  --user=deploy \
  --group=deploy \
  --runner=upstart-1.5 \
  --version="$(cat VERSION)" \
   --buildpack=git@github.com:ph3nx/heroku-binary-buildpack.git \
  --compile-cache-dir=$cacheRoot/compile \
  --buildpacks-cache-dir=$cacheRoot/build

mv *.deb ${ROOT}/
