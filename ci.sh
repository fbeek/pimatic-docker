#!/bin/bash
echo
echo $DOCKER_PASSWORD | docker login -u fbeek --password-stdin
TAG="${TRAVIS_TAG:-latest}"
echo "$DOCKER_PASSWORD $TAG"
docker buildx build \
     --progress plain \
    --platform=linux/amd64,linux/arm64,linux/arm/v7 \
    -t $DOCKER_REPO:$TAG \
    --push \
    .