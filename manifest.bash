#!/bin/bash
set -Ceu
REPO="harbor.inux39.me/private"
DATE=$(date +%Y%m%d%H%M%S)
SH_ROOT="$(cd $(dirname "$0"); pwd)"
TAG="${1:-$DATE}"
TARGET="${2-:ALL}"

function manifest() {
  IMAGE="harbor.inux39.me/private/$1"
  echo "[INFO] Start build $IMAGE:$TAG ($REPO/$IMAGE:$TAG)"
  podman manifest create "$IMAGE:$TAG"
  podman manifest add --pull "$IMAGE:$TAG" "$IMAGE:build-x86_64"
  podman manifest add --pull "$IMAGE:$TAG" "$IMAGE:build-aarch64"
  podman manifest push "$IMAGE:$TAG"
  echo "[INFO] Complete build $IMAGE:$TAG ($REPO/$IMAGE:$TAG)"
}

case "$TARGET" in
  mastodon )
    manifest "mastodon"
    ;;
  mastodon-streaming )
    manifest "mastodon-streaming"
    ;;
  * )
    manifest "mastodon"
    manifest "mastodon-streaming"
    ;;
esac

