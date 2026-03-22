#!/bin/bash
set -Ceu
REPO="harbor.inux39.me/private"
DATE=$(date +%Y%m%d%H%M%S)
SH_ROOT="$(cd $(dirname "$0"); pwd)"

function manifest() {
  IMAGE="harbor.inux39.me/private/$1"
  TAG="$2"
  echo "[INFO] Start build $IMAGE:$TAG ($REPO/$IMAGE:$TAG)"
  podman manifest create "$IMAGE:$TAG"
  podman manifest add "$IMAGE:$TAG" "$IMAGE:x86_64"
  podman manifest add "$IMAGE:$TAG" "$IMAGE:aarch64"
  podman manifest push "$IMAGE:$TAG"
  echo "[INFO] Complete build $IMAGE:$TAG ($REPO/$IMAGE:$TAG)"
}

manifest "mastodon" "$1"
manifest "mastodon-streaming" "$1"

