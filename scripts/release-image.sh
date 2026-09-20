#!/usr/bin/env bash
# Usage : release-image.sh <nom-image> <version X.Y.Z>
# Exemple (dans le dossier du Dockerfile) : release-image.sh user-service 1.1.0
set -euo pipefail

REGISTRY="ghcr.io/zayedhamadi"
NAME="${1:-}"
VERSION="${2:-}"

if [[ -z "$NAME" || ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Usage : $0 <nom-image> <version X.Y.Z>   ex : $0 user-service 1.1.0"
  exit 1
fi

MAJOR="${VERSION%%.*}"
MINOR="${VERSION%.*}"
IMAGE="$REGISTRY/$NAME"

if docker manifest inspect "$IMAGE:$VERSION" > /dev/null 2>&1; then
  echo "ERREUR : $IMAGE:$VERSION existe deja. Une version exacte ne se repousse jamais."
  exit 1
fi

echo "==> Build de $IMAGE:$VERSION"
docker build -t "$IMAGE:$VERSION" .

echo "==> Tags supplementaires"
docker tag "$IMAGE:$VERSION" "$IMAGE:$MINOR"
docker tag "$IMAGE:$VERSION" "$IMAGE:$MAJOR"
docker tag "$IMAGE:$VERSION" "$IMAGE:latest"

echo "==> Push"
for tag in "$VERSION" "$MINOR" "$MAJOR" latest; do
  docker push "$IMAGE:$tag"
done
echo "OK : $IMAGE -> $VERSION, $MINOR, $MAJOR, latest"
