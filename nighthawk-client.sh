#!/bin/bash
set -e
BASE_DIR=${BASE_DIR:=./}
CPU_SET=${CPU_SET:=40-43}
CONNECTIONS=${CONNECTIONS:=100}
DURATION=${DURATION:=120}
CONCURRENCY=${CONCURRENCY:=4}
TARGET=${TARGET:=http://127.0.0.1:13333/}
REQUEST_BODY_SIZE=${REQUEST_BODY_SIZE:=0}
REQUEST_METHOD=${REQUEST_METHOD:=GET}
MAX_REQUEST_PER_CONNECTION=${MAX_REQUEST_PER_CONNECTION:=4294937295}


TRANSPORT_OPT=${TRANSPORT_OPT:=}

for rps in `seq $RPS_START $RPS_INCREASE $RPS_END`; do

  taskset -c $CPU_SET ~/go/src/github.com/envoyproxy/nighthawk/bazel-bin/nighthawk_client \
    --rps $rps --connections $CONNECTIONS --duration $DURATION --concurrency $CONCURRENCY -v info $TRANSPORT_OPT --request-body-size ${REQUEST_BODY_SIZE} --request-method $REQUEST_METHOD --max-requests-per-connection ${MAX_REQUEST_PER_CONNECTION} \
    --output-format fortio http://192.168.222.10:13333/ > ${BASE_DIR}/nighthawk_rps_${rps}_connections_${CONNECTIONS}_concurrency_${CONCURRENCY}_duration_${DURATION}.json

done