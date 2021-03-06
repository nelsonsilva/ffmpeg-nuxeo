#!/bin/bash -e

TAG="v1.0.0"

if [ -d "libvpx" ]; then
    pushd libvpx
    if [ -f "Makefile" ]; then
        make clean || true
    fi
    git checkout master
    git pull
    popd
else
    git clone http://git.chromium.org/webm/libvpx.git
fi

pushd libvpx
git checkout $TAG
./configure
make
MAJOR=$(grep '#define VERSION_MAJOR' vpx_version.h | awk '{print $3}')
MINOR=$(grep '#define VERSION_MINOR' vpx_version.h | awk '{print $3}')
PATCH=$(grep '#define VERSION_PATCH' vpx_version.h | awk '{print $3}')
VERSION="$MAJOR.$MINOR.$PATCH"
echo "libvpx - Nuxeo version" > description-pak
checkinstall --pkgname=libvpx-nuxeo --pkgversion="$VERSION" \
    --conflicts=libvpx-dev --replaces=libvpx-dev \
    --provides=libvpx-dev \
    --maintainer="'Nuxeo Packagers <packagers@nuxeo.com>'" \
    --backup=no --deldoc=yes --deldesc=yes --fstrans=no --default
popd

