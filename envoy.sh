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
PERF_TOOL=${PERF_TOOL:=pprof}

BASE_ID=`od -An -N4 -tu4 < /dev/urandom`
#ulimit -n 1048576
if [ $PERF_ENABLED = 0 ]; then
    sudo sysctl -w kernel.perf_event_paranoid=-1
    echo 0 | sudo tee /proc/sys/kernel/kptr_restrict
    taskset -c ${ENVOY_CPU_SET} ${ENVOY_BIN} --base-id $BASE_ID --config-path $ENVOY_CONFIG --concurrency $ENVOY_CONCURRENCY > ./envoy.log 2>&1 &
else
    if [ $PERF_TOOL = pprof ]; then
        export CPUPROFILE=$BASE_DIR/envoy.cpuprof
        taskset -c ${ENVOY_CPU_SET} ${ENVOY_BIN} --base-id $BASE_ID --config-path $ENVOY_CONFIG --concurrency $ENVOY_CONCURRENCY > ./envoy.log 2>&1 &
    elif [ $PERF_TOOL = perf ]; then
        sudo taskset -c $PERF_CPUSET perf record -g -o ${BASE_DIR}/perf.data -- taskset -c ${ENVOY_CPU_SET} ${ENVOY_BIN} --base-id $BASE_ID --config-path $ENVOY_CONFIG --concurrency $ENVOY_CONCURRENCY > ./envoy.log 2>&1 &
    fi
fi

echo "$!" > envoy.pid
echo "envoy started"
