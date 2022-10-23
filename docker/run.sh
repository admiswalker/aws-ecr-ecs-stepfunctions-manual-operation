#!/bin/sh

ECR_REPOSITORY_NAME=example_1023

docker run \
       -u `id -u`:`id -g` \
       -v /etc/group:/etc/group:ro \
       -v /etc/passwd:/etc/passwd:ro \
       -v /etc/shadow:/etc/shadow:ro \
       -v /etc/sudoers.d:/etc/sudoers.d:ro \
       --rm -it --name ${ECR_REPOSITORY_NAME} \
       -v $PWD:/home -w /home \
       --env AWS_ACCESS_KEY_ID --env AWS_SECRET_ACCESS_KEY --env AWS_SESSION_TOKEN \
       ${ECR_REPOSITORY_NAME}:latest bash

