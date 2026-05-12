#!/bin/sh
set -eu

REPO="${QMANAGER_CFW3212_REPO:-Joetooley28/qmanager-casa-cfw3212-package}"
TAG="${QMANAGER_CFW3212_TAG:-v0.1.9-cfw3212.1}"
VERSION="${QMANAGER_CFW3212_VERSION:-v0.1.9}"
BASE_URL="${QMANAGER_CFW3212_BASE_URL:-https://github.com/$REPO/releases/download/$TAG}"
WORK_DIR="${QMANAGER_CFW3212_WORK_DIR:-/tmp/qmanager-cfw3212-uninstall}"
TARBALL_NAME="qmanager-cfw3212-$VERSION.tar.gz"
SHA_NAME="qmanager-cfw3212-$VERSION.sha256"

download() {
    url="$1"
    out="$2"

    if command -v curl >/dev/null 2>&1; then
        curl -fL --connect-timeout 20 -o "$out" "$url"
    elif command -v wget >/dev/null 2>&1; then
        wget -O "$out" "$url"
    else
        echo "ERROR: curl or wget is required." >&2
        exit 1
    fi
}

if [ "$(id -u)" != "0" ]; then
    echo "ERROR: run this uninstaller as root on the Casa CFW-3212." >&2
    exit 1
fi

for cmd in tar gzip sha256sum; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: missing required command: $cmd" >&2
        exit 1
    fi
done

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "[qmanager-cfw3212] Downloading $TARBALL_NAME"
download "$BASE_URL/$TARBALL_NAME" "$TARBALL_NAME"

echo "[qmanager-cfw3212] Downloading $SHA_NAME"
download "$BASE_URL/$SHA_NAME" "$SHA_NAME"

echo "[qmanager-cfw3212] Verifying checksum"
sha256sum -c "$SHA_NAME"

echo "[qmanager-cfw3212] Extracting package"
tar xzf "$TARBALL_NAME"

echo "[qmanager-cfw3212] Running Casa uninstaller"
exec sh "$WORK_DIR/qmanager_install/uninstall_cfw3212.sh" --force --no-reboot "$@"
