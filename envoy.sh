#!/bin/bash

set -e

ENVOY_CPU_SET=${ENVOY_CPU_SET:=13-17}
ENVOY_CONCURRENCY=${ENVOY_CONCURRENCY:=4}
ENVOY_BIN=${ENVOY_BIN:=/home/xhj/envoy/bazel-bin/contrib/exe/envoy-static}
ENVOY_CONFIG=${ENVOY_CONFIG:=}
BASE_DIR=${BASE_DIR:=.}
mkdir -p $BASE_DIR

PERF_ENABLED=${PERF_ENABLED:=0}
PERF_CPUSET=${PERF_CPUSET:=24-47}

BASE_ID=`od -An -N4 -tu4 < /dev/urandom`
#ulimit -n 1048576
if [ $PERF_ENABLED = 0 ]; then
    taskset -c ${ENVOY_CPU_SET} ${ENVOY_BIN} --base-id $BASE_ID --config-path $ENVOY_CONFIG --concurrency $ENVOY_CONCURRENCY > ./envoy.log 2>&1 &
else
    export CPUPROFILE=$BASE_DIR/envoy.cpuprof
    taskset -c ${ENVOY_CPU_SET} ${ENVOY_BIN} --base-id $BASE_ID --config-path $ENVOY_CONFIG --concurrency $ENVOY_CONCURRENCY > ./envoy.log 2>&1 &
    #sudo taskset -c $PERF_CPUSET perf record -g -o ${BASE_DIR}/perf.data -- taskset -c ${ENVOY_CPU_SET} ${ENVOY_BIN} --base-id $BASE_ID --config-path $ENVOY_CONFIG --concurrency $ENVOY_CONCURRENCY > ./envoy.log 2>&1 &
fi

echo "$!" > envoy.pid
echo "envoy started"
