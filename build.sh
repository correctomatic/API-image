#! /usr/bin/env bash

# Read .env file
export $(grep -v '^#' .env | xargs)

docker build \
    --build-arg REPO_URL=$REPO_URL \
    --build-arg REPO_BRANCH=$REPO_BRANCH \
    --tag correctomatic/$IMAGE_NAME:$IMAGE_TAG \
    --tag $DOCKERHUB_USER/$IMAGE_NAME:latest \
    "$@" \
    .
