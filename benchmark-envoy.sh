#!/bin/bash

set -e

# Clean up running data first
echo "" > ./running_data.sh

# Running fortio server
export FORTIO_CPU_SET=54-61
bash ./fortio-server.sh

# Running envoy
export ENVOY_CPU_SET=${ENVOY_CPU_SET:=13-17} # 5 cpu pinning, 4 for worker threads, 1 for main thread
export ENVOY_CONCURRENCY=${ENVOY_CONCURRENCY:=4} # 4 workers
export ENVOY_CONFIG=${ENVOY_CONFIG}
bash ./envoy.sh

sleep 5 # ensure envoy and fortio startup

# Running client
export BASE_DIR=${BASE_DIR}
export CPU_SET=${CPU_SET:=40-43} # 4 cpu pinning
export CONCURRENCY=${CONCURRENCY:=4}
export RPS_START=${RPS_START:=5000}
export RPS_INCREASE=${RPS_INCREASE:=5000}
export RPS_END=${RPS_END:=100000}
mkdir -p $BASE_DIR
bash ./nighthawk-client.sh

source ./running_data.sh

kill -9 $ENVOY_PID
kill -9 $FORTIO_PID