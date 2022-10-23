#!/bin/bash
SCRIPT_DIR=`cd $(dirname ${BASH_SOURCE:-$0}); pwd`

ECR_REPOSITORY_NAME=example_1023
docker build -t ${ECR_REPOSITORY_NAME} $SCRIPT_DIR
#docker build -t docker_aws_ecr_ecs_test $SCRIPT_DIR

