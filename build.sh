#!/bin/bash

set -eo pipefail

dr=$(dirname $(realpath $0))
pushd $dr >/dev/null

BUILD_HOST=labca-$(git describe --always 2>/dev/null)
BUILD_IMAGE=$(eval echo $(grep boulder-tools patches/docker-compose.patch | head -1 | sed -e "s/image://" | sed -e "s/&boulder_image //"))

TMP_DIR=$dr/tmp
rm -rf $TMP_DIR && mkdir -p $TMP_DIR/{admin,bin,logs}

#cp -rp $dr/gui/* $TMP_DIR/admin/
#sed -i -e "s/^bin\/labca//" $TMP_DIR/admin/setup.sh
#sed -i '/^$/d' $TMP_DIR/admin/setup.sh
mkdir $TMP_DIR/admin/templates
echo TODO > $TMP_DIR/admin/templates/TODO
touch $TMP_DIR/labca
touch $TMP_DIR/admin/setup.sh

echo
BASEDIR=/go/src/github.com/letsencrypt/boulder
docker run -i -v $dr/boulder:$BASEDIR:cached -v $TMP_DIR/bin:$BASEDIR/bin -w $BASEDIR -e BUILD_HOST=$BUILD_HOST $BUILD_IMAGE make build

#echo
#BASEDIR=/go/src/labca
#docker run -i -v $TMP_DIR/admin:$BASEDIR:cached -v $TMP_DIR:$BASEDIR/bin -w $BASEDIR $BUILD_IMAGE ./setup.sh

echo
./upx -q $(find tmp/ -type f ! -size 0 -exec grep -IL . "{}" \;)
echo

popd >/dev/null
