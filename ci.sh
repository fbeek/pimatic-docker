#!/bin/bash


docker buildx build \
  --progress plain \
  --platform=linux/amd64,linux/arm64,linux/arm/v7 \
  .
exit $?
