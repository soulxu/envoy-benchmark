#!/bin/bash

set -e

ENVOY_CPU_SET=${ENVOY_CPU_SET:=13-17}
ENVOY_CONCURRENCY=${ENVOY_CONCURRENCY:=4}
ENVOY_BIN=${ENVOY_BIN:=/home/xhj/envoy/bazel-bin/contrib/exe/envoy-static}
ENVOY_CONFIG=${ENVOY_CONFIG:=}
BASE_DIR=${BASE_DIR:=.}
mkdir -p $BASE_DIR

BASE_ID=`od -An -N4 -tu4 < /dev/urandom`
#ulimit -n 1048576
taskset -c ${ENVOY_CPU_SET} ${ENVOY_BIN} --base-id $BASE_ID --config-path $ENVOY_CONFIG --concurrency $ENVOY_CONCURRENCY > ./envoy.log 2>&1 &

echo "$!" > envoy.pid
echo "envoy started"
