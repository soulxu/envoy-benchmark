#!/bin/bash

set -e

# Clean up running data first
#echo "" > ./running_data.sh
export BASE_DIR=${BASE_DIR}

# Running fortio server
export FORTIO_CPU_SET=${FORTIO_CPU_SET:=54-61}
echo "start fortio server on $FORTIO_HOST"
ssh -i $SSH_KEY hejiexu@$FORTIO_HOST "cd /home/hejiexu/cpu-affinity-benchmark; PATH=$PATH:/home/hejiexu/go/bin FORTIO_CPU_SET=$FORTIO_CPU_SET bash ./fortio-server.sh"
# bash ./fortio-server.sh

# Running envoy
export ENVOY_CPU_SET=${ENVOY_CPU_SET:=13-17} # 5 cpu pinning, 4 for worker threads, 1 for main thread
export ENVOY_CONCURRENCY=${ENVOY_CONCURRENCY:=4} # 4 workers
export ENVOY_CONFIG=${ENVOY_CONFIG}

echo "start envoy on $ENVOY_HOST"
ssh -i $SSH_KEY hejiexu@$ENVOY_HOST "cd /home/hejiexu/cpu-affinity-benchmark; BASE_DIR=$BASE_DIR ENVOY_CPU_SET=$ENVOY_CPU_SET ENVOY_CONCURRENCY=$ENVOY_CONCURRENCY ENVOY_CONFIG=$ENVOY_CONFIG bash ./envoy.sh"
# bash ./envoy.sh

sleep 5 # ensure envoy and fortio startup

# Running client
export CPU_SET=${CPU_SET:=40-43} # 4 cpu pinning
export CONCURRENCY=${CONCURRENCY:=4}
export RPS_START=${RPS_START:=5000}
export RPS_INCREASE=${RPS_INCREASE:=5000}
export RPS_END=${RPS_END:=100000}
mkdir -p $BASE_DIR
bash -x ./nighthawk-client.sh

# collect envoy metrics
curl 192.168.222.10:9901/stats > $BASE_DIR/envoy_stats.txt

SUMMARY_FILE=$BASE_DIR/summary.txt
touch $SUMMARY_FILE
echo "# Envoy enviroment as below" >> $SUMMARY_FILE
echo "ENVOY_CPU_SET=${ENVOY_CPU_SET:=13-17}" >> $SUMMARY_FILE
echo "ENVOY_CONCURRENCY=${ENVOY_CONCURRENCY:=4}" >> $SUMMARY_FILE
echo "ENVOY_BIN=${ENVOY_BIN:=/home/hejiexu/go/src/github.com/envoyproxy/envoy/bazel-bin//source/exe/envoy-static}" >> $SUMMARY_FILE
echo "ENVOY_CONFIG=${ENVOY_CONFIG:=}" >> $SUMMARY_FILE

echo ""

echo "# Fortio server enviroment as below" >> $SUMMARY_FILE
echo "FORTIO_CPU_SET=${FORTIO_CPU_SET:=50-59}" >> $SUMMARY_FILE

echo ""

echo "# Nighthawk client enviroment as below" >> $SUMMARY_FILE
echo "CPU_SET=${CPU_SET:=40-43}" >> $SUMMARY_FILE
echo "CONNECTIONS=${CONNECTIONS:=100}" >> $SUMMARY_FILE
echo "DURATION=${DURATION:=120}" >> $SUMMARY_FILE
echo "CONCURRENCY=${CONCURRENCY:=4}" >> $SUMMARY_FILE
echo "TARGET=${TARGET:=http://127.0.0.1:13333/}" >> $SUMMARY_FILE
echo "REQUEST_BODY_SIZE=${REQUEST_BODY_SIZE:=0}" >> $SUMMARY_FILE
echo "MAX_REQUEST_PER_CONNECTION=${MAX_REQUEST_PER_CONNECTION:=4294937295}" >> $SUMMARY_FILE
echo "TRANSPORT_OPT=${TRANSPORT_OPT:=}" >> $SUMMARY_FILE

bash ./cleanup.sh

# local cleanup
#source ./running_data.sh
#kill -9 $ENVOY_PID
#kill -9 $FORTIO_PID