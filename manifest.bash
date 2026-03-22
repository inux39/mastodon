#!/bin/bash
set -Ceu
REPO="harbor.inux39.me/private"
DATE=$(date +%Y%m%d%H%M%S)
SH_ROOT="$(cd $(dirname "$0"); pwd)"
ARG="${1-:ALL}"

function manifest() {
  IMAGE="harbor.inux39.me/private/$1"
  TAG="$2"
  echo "[INFO] Start build $IMAGE:$TAG ($REPO/$IMAGE:$TAG)"
  podman manifest create "$IMAGE:$TAG"
  podman manifest add "$IMAGE:$TAG" "$IMAGE:${TAG}-x86_64"
  podman manifest add "$IMAGE:$TAG" "$IMAGE:${TAG}-aarch64"
  podman manifest push "$IMAGE:$TAG"
  echo "[INFO] Complete build $IMAGE:$TAG ($REPO/$IMAGE:$TAG)"
}

case "$ARG" in
  mastodon )
    manifest "mastodon" "$1"
    ;;
  streaming )
    manifest "streaming" "$1"
    ;;
  * )
    manifest "mastodon" "$1"
    manifest "streaming" "$1"
    ;;
esac

