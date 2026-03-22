#!/bin/bash
set -Ceu
REPO="harbor.inux39.me/private"
DATE=$(date +%Y%m%d%H%M%S)
SH_ROOT="$(cd $(dirname "$0"); pwd)"
COMMIT_ID="$(git show -s --format=%H)"
TAG="build-$(uname -m)-${COMMIT_ID}"

RUBY_VERSION="4.0.6"

function platform() {
  case "$(uname -m)" in
    x86_64 )
      echo "linux/amd64"
      ;;
    aarch64 )
      echo "linux/arm64"
      ;;
    * )
      ;;
  esac
}

function build() {
  IMAGE="$1"
  FILE="$2"
  echo "[INFO] Start build $IMAGE:$TAG ($REPO/$IMAGE:$TAG)"
  podman build \
    --pull=always \
    --build-arg BASE_REGISTRY="harbor.inux39.me/docker" \
    --build-arg RUBY_VERSION="$RUBY_VERSION" \
    --platform="$(platform)" \
    --tag "$REPO/$IMAGE:$TAG" \
    --format docker \
    --file "$FILE" .
  podman push "$REPO/$IMAGE:$TAG"
  echo "[INFO] Complete build $IMAGE:$TAG ($REPO/$IMAGE:$TAG)"
}

ARG="${1:-mastodon}"
case "$ARG" in
  mastodon )
    build "mastodon" "$SH_ROOT/Dockerfile"
    ;;
  mastodon-streaming )
    build "streaming" "$SH_ROOT/streaming/Dockerfile"
    ;;
  all )
    build "mastodon" "$SH_ROOT/Dockerfile"
    build "streaming" "$SH_ROOT/streaming/Dockerfile"
    ;;
  * )
    echo "$(basename $0) [all/mastodon/streaming]"
    exit 0
    ;;
esac


