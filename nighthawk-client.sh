#!/bin/bash
# set -e
# set -x
BASE_DIR=${BASE_DIR:=./}
LOAD_CPU_SET=${LOAD_CPU_SET:=40-43}
LOAD_CONNECTIONS=${LOAD_CONNECTIONS:=100}
LOAD_DURATION=${LOAD_DURATION:=120}
LOAD_CONCURRENCY=${LOAD_CONCURRENCY:=4}
LOAD_TARGET=${LOAD_TARGET:=http://127.0.0.1:13333/}
LOAD_REQUEST_BODY_SIZE=${LOAD_REQUEST_BODY_SIZE:=0}
LOAD_REQUEST_METHOD=${LOAD_REQUEST_METHOD:=GET}
LOAD_MAX_REQUEST_PER_CONNECTION=${LOAD_MAX_REQUEST_PER_CONNECTION:=4294937295}
LOAD_TRANSPORT_OPT=${LOAD_TRANSPORT_OPT:=}
LOAD_OTHER_OPT=${LOAD_OTHER_OPT:=}
LOAD_MAX_ACTIVE_REQUESTS=${LOAD_MAX_ACTIVE_REQUESTS:=100000}
LOAD_MODE=${LOAD_MODE:=closed}
NIGHTHAWK_CLIENT=${NIGHTHAWK_CLIENT:=/home/xhj/nighthawk/bazel-bin/nighthawk_client}
PERF_LOAD_CPUSET=${PERF_LOAD_CPUSET:=24-47}

NIGHTHAWK_OPEN_LOOP_OPT=""
if [ $LOAD_MODE = "open" ]; then
    NIGHTHAWK_OPEN_LOOP_OPT="--open-loop"
fi

#taskset -c $LOAD_CPU_SET /home/xhj/nighthawk/bazel-bin/nighthawk_client \
#    --rps $LOAD_RPS $LOAD_OTHER_OPT --connections $LOAD_CONNECTIONS --duration $LOAD_DURATION --concurrency $LOAD_CONCURRENCY -v info $LOAD_TRANSPORT_OPT --request-body-size ${LOAD_REQUEST_BODY_SIZE} --request-method $LOAD_REQUEST_METHOD --max-requests-per-connection ${LOAD_MAX_REQUEST_PER_CONNECTION} \
#    --timeout 120 --output-format fortio $LOAD_TARGET > ${BASE_DIR}/nighthawk_result.json

if [ $PERF_LOAD = "perf" ]; then
    taskset -c $PERF_LOAD_CPUSET perf record -g -o ${BASE_DIR}/perf.data -- taskset -c $LOAD_CPU_SET $NIGHTHAWK_CLIENT \
    --rps $LOAD_RPS $LOAD_OTHER_OPT --connections $LOAD_CONNECTIONS --duration $LOAD_DURATION --concurrency $LOAD_CONCURRENCY -v warn $LOAD_TRANSPORT_OPT --request-body-size ${LOAD_REQUEST_BODY_SIZE} --request-method $LOAD_REQUEST_METHOD --max-requests-per-connection ${LOAD_MAX_REQUEST_PER_CONNECTION} \
    --timeout 120 $NIGHTHAWK_OPEN_LOOP_OPT --max-active-requests ${LOAD_MAX_ACTIVE_REQUESTS} $LOAD_TARGET > ${BASE_DIR}/nighthawk_result.result || true
else
    taskset -c $LOAD_CPU_SET $NIGHTHAWK_CLIENT \
        --rps $LOAD_RPS $LOAD_OTHER_OPT --connections $LOAD_CONNECTIONS --duration $LOAD_DURATION --concurrency $LOAD_CONCURRENCY -v warn $LOAD_TRANSPORT_OPT --request-body-size ${LOAD_REQUEST_BODY_SIZE} --request-method $LOAD_REQUEST_METHOD --max-requests-per-connection ${LOAD_MAX_REQUEST_PER_CONNECTION} \
        --timeout 120 $NIGHTHAWK_OPEN_LOOP_OPT --max-active-requests ${LOAD_MAX_ACTIVE_REQUESTS} $LOAD_TARGET > ${BASE_DIR}/nighthawk_result.result || true
fi