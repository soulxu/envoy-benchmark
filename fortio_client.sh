#!/bin/bash
set -e
set -x
BASE_DIR=${BASE_DIR:=./}
LOAD_CPU_SET=${LOAD_CPU_SET:=0-47}
LOAD_CONNECTIONS=${LOAD_CONNECTIONS:=64}
LOAD_DURATION=${LOAD_DURATION:=60}
LOAD_CONCURRENCY=${LOAD_CONCURRENCY:=8}
LOAD_TARGET=${LOAD_TARGET:=http://127.0.0.1:13333/}
LOAD_REQUEST_BODY_SIZE=${LOAD_REQUEST_BODY_SIZE:=0}
LOAD_REQUEST_METHOD=${LOAD_REQUEST_METHOD:=GET}
LOAD_MAX_REQUEST_PER_CONNECTION=${LOAD_MAX_REQUEST_PER_CONNECTION:=4294937295}

LOAD_TRANSPORT_OPT=${LOAD_TRANSPORT_OPT:=}
LOAD_OTHER_OPT=${LOAD_OTHER_OPT:=}

taskset -c $LOAD_CPU_SET fortio load -httpbufferkb 40960 \
    -qps 0 -c $LOAD_CONNECTIONS -t ${LOAD_DURATION}s -payload-size ${LOAD_REQUEST_BODY_SIZE} $LOAD_OTHER_OPT $LOAD_TARGET 2> ${BASE_DIR}/fortio_result.result

