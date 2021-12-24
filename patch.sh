#!/bin/bash

set -o pipefail

dr=$(dirname $(realpath $0))
r=0

cd $dr/boulder
for p in $(find $dr/patches -type f | sort); do
    echo "== $p"
    patch -p1 <$p
    let r=r+$?
    if [ $r -gt 0 ]; then exit 9; fi
done
cd - >/dev/null

exit $r
