#!/bin/sh

set -eu

export VERSION=${VERSION:-0.0.0}
echo "Building version $VERSION"
export GOFLAGS="'-ldflags=-w -s \"-X=github.com/jmorganca/ollama/version.Version=$VERSION\" \"-X=github.com/jmorganca/ollama/server.mode=release\"'"

docker buildx build \
    --load \
    --platform=linux/amd64 \
    --build-arg=VERSION \
    --build-arg=GOFLAGS \
    -f Dockerfile.slim \
    -t ollama:slim \
    .
