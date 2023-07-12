#!/bin/bash

set -e

# Clean up running data first
#echo "" > ./running_data.sh
export BASE_DIR=${BASE_DIR:=./result}

# Running fortio server
export FORTIO_CPU_SET=${FORTIO_CPU_SET:=54-61}
echo "start fortio server on $FORTIO_HOST"
# ssh -i $SSH_KEY hejiexu@$FORTIO_HOST "cd /home/hejiexu/cpu-affinity-benchmark; PATH=$PATH:/home/hejiexu/go/bin FORTIO_CPU_SET=$FORTIO_CPU_SET bash ./fortio-server.sh"
bash -x ./fortio-server.sh

# Running envoy
export ENVOY_CPU_SET=${ENVOY_CPU_SET:=13-16} # 5 cpu pinning, 4 for worker threads, 1 for main thread
export ENVOY_CONCURRENCY=${ENVOY_CONCURRENCY:=4} # 4 workers
export ENVOY_CONFIG=${ENVOY_CONFIG:=./envoy-http.yaml}

echo "start envoy on $ENVOY_HOST"
# ssh -i $SSH_KEY hejiexu@$ENVOY_HOST "cd /home/hejiexu/cpu-affinity-benchmark; BASE_DIR=$BASE_DIR ENVOY_CPU_SET=$ENVOY_CPU_SET ENVOY_CONCURRENCY=$ENVOY_CONCURRENCY ENVOY_CONFIG=$ENVOY_CONFIG bash ./envoy.sh"
bash -x ./envoy.sh

echo "waiting for envoy and fortio startup"
sleep 8 # ensure envoy and fortio startup

echo "start nighthawk"
# Running client
export NIGHTHAWK_CPU_SET=${NIGHTHAWK_CPU_SET:=40-43} # 4 cpu pinning
export NIGHTHAWK_CONCURRENCY=${NIGHTHAWK_CONCURRENCY:=4}
export NIGHTHAWK_RPS=${NIGHTHAWK_RPS:=5000}
export NIGHTHAWK_DURATION=${NIGHTHAWK_DURATION:=10}
#export NIGHTHAWK_RPS_START=${NIGHTHAWK_RPS_START:=5000}
#export NIGHTHAWK_RPS_INCREASE=${NIGHTHAWK_RPS_INCREASE:=5000}
#export NIGHTHAWK_RPS_END=${NIGHTHAWK_RPS_END:=10000}

mkdir -p $BASE_DIR
if [ $CLIENT = "nh" ]; then
    bash -x ./nighthawk-client.sh
else
    bash -x ./fortio_client.sh
fi

# collect envoy metrics
# curl 192.168.222.10:9901/stats > $BASE_DIR/envoy_stats.txt

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
echo "NIGHTHAWK_CPU_SET=${NIGHTHAWK_CPU_SET:=40-43}" >> $SUMMARY_FILE
echo "NIGHTHAWK_CONNECTIONS=${NIGHTHAWK_CONNECTIONS:=100}" >> $SUMMARY_FILE
echo "NIGHTHAWK_RPS=${NIGHTHAWK_RPS:=}" >> $SUMMARY_FILE
echo "NIGHTHAWK_DURATION=${NIGHTHAWK_DURATION:=120}" >> $SUMMARY_FILE
echo "NIGHTHAWK_CONCURRENCY=${NIGHTHAWK_CONCURRENCY:=4}" >> $SUMMARY_FILE
echo "NIGHTHAWK_TARGET=${NIGHTHAWK_TARGET:=http://127.0.0.1:13333/}" >> $SUMMARY_FILE
echo "NIGHTHAWK_REQUEST_BODY_SIZE=${NIGHTHAWK_REQUEST_BODY_SIZE:=0}" >> $SUMMARY_FILE
echo "NIGHTHAWK_MAX_REQUEST_PER_CONNECTION=${NIGHTHAWK_MAX_REQUEST_PER_CONNECTION:=4294937295}" >> $SUMMARY_FILE
echo "NIGHTHAWK_TRANSPORT_OPT=${NIGHTHAWK_TRANSPORT_OPT:=}" >> $SUMMARY_FILE
echo "NIGHTHAWK_OTHER_OPT=${NIGHTHAWK_OTHER_OPT}" >> $SUMMARY_FILE

# collect envoy state
curl 127.0.0.1:9901/stats > $BASE_DIR/envoy_stats.txt

bash ./cleanup.sh

# local cleanup
#source ./running_data.sh
#kill -9 $ENVOY_PID
#kill -9 $FORTIO_PID