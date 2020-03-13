#!/bin/bash

if [ "$TRAVIS_BRANCH" == "develop" ]; then
    docker login -u "$DOCKER_USER" -p "$DOCKER_PASSWORD"
    docker tag "$IMAGE_NAME" "${IMAGE_NAME}:latest"
    docker tag "$IMAGE_NAME" "${IMAGE_NAME}:${version}"
    docker push "${IMAGE_NAME}:latest" && docker push "${IMAGE_NAME}:${version}"
fi
