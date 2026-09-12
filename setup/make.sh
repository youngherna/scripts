#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?uso: make.sh <version>}"
TARBALL="make-${VERSION}.tar.gz"
SRCDIR="/tmp/make-${VERSION}"

cd /tmp || exit 1

rm -rf "${SRCDIR}" "${TARBALL}"*
curl -fL --retry 3 -o "${TARBALL}" \
    "https://ftpmirror.gnu.org/make/${TARBALL}"

if [[ "$(stat -c%s "${TARBALL}")" -lt 500000 ]]; then
    echo "ERROR: descarga invalida ($(stat -c%s "${TARBALL}") bytes)" >&2
    exit 1
fi

tar xzf "${TARBALL}"
cd "${SRCDIR}" || exit 1

./configure --prefix=/usr/local
bash ./build.sh
sudo install -m 755 ./make /usr/local/bin/make

cd /tmp || exit 1
rm -rf "${SRCDIR}" "${TARBALL}"

echo "OK: make ${VERSION} instalado en /usr/local/bin/make"