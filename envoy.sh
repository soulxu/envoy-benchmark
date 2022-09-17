#!/bin/bash

set -e

ENVOY_CPU_SET=${ENVOY_CPU_SET:=13-17}
ENVOY_CONCURRENCY=${ENVOY_CONCURRENCY:=4}
ENVOY_BIN=${ENVOY_BIN:=/home/hejiexu/go/src/github.com/envoyproxy/envoy/bazel-bin//source/exe/envoy-static}
ENVOY_CONFIG=${ENVOY_CONFIG:=}
BASE_DIR=${BASE_DIR:=.}
mkdir -p $BASE_DIR
ulimit -n 1048576
taskset -c ${ENVOY_CPU_SET} ${ENVOY_BIN} --base-id 1 --config-path $ENVOY_CONFIG --concurrency $ENVOY_CONCURRENCY > ./envoy.log 2>&1 &

echo "$!" > envoy.pid
echo "envoy started"
