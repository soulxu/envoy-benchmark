#!/bin/bash

set -e

# All the binary path
source ./env.sh

# Clean up running data first
#echo "" > ./running_data.sh
export BASE_DIR=${BASE_DIR:=./result}

export LOAD_CLIENT=${LOAD_CLIENT:=fortio}
export BACK_SERVER=${BACK_SERVER:=fortio}

# Running fortio server
export BACKEND_CPU_SET=${BACKEND_CPU_SET:=54-61}
echo "start backend server $BACK_SERVER on $FORTIO_HOST"
# ssh -i $SSH_KEY hejiexu@$FORTIO_HOST "cd /home/hejiexu/cpu-affinity-benchmark; PATH=$PATH:/home/hejiexu/go/bin BACKEND_CPU_SET=$BACKEND_CPU_SET bash ./fortio-server.sh"

if [ $BACK_SERVER = "fortio" ]; then
    bash -x ./fortio-server.sh
elif [ $BACK_SERVER = "nighthawk" ]; then
    bash -x ./nighthawk-server.sh
else
    echo "Not supported back server: $BACK_SERVER"
    exit 1
fi

# Running envoy
export ENVOY_CPU_SET=${ENVOY_CPU_SET:=13-16} # 5 cpu pinning, 4 for worker threads, 1 for main thread
export ENVOY_CONCURRENCY=${ENVOY_CONCURRENCY:=4} # 4 workers
export ENVOY_CONFIG=${ENVOY_CONFIG:=./envoy-http.yaml}

echo "start envoy on $ENVOY_HOST"
# ssh -i $SSH_KEY hejiexu@$ENVOY_HOST "cd /home/hejiexu/cpu-affinity-benchmark; BASE_DIR=$BASE_DIR ENVOY_CPU_SET=$ENVOY_CPU_SET ENVOY_CONCURRENCY=$ENVOY_CONCURRENCY ENVOY_CONFIG=$ENVOY_CONFIG bash ./envoy.sh"
bash -x ./envoy.sh

echo "waiting for envoy and $BACK_SERVER server startup"
sleep 8 # ensure envoy and fortio startup

echo "start load client $LOAD_CLIENT"
# Running client
export LOAD_CPU_SET=${LOAD_CPU_SET:=40-43} # 4 cpu pinning
export LOAD_CONCURRENCY=${LOAD_CONCURRENCY:=4}
export LOAD_RPS=${LOAD_RPS:=5000}
export LOAD_DURATION=${LOAD_DURATION:=10}
export LOAD_CONNECTIONS=${LOAD_CONNECTIONS:=64}

echo "start mpstat to collect the CPU stats"
export MPSTAT_INTERVAL=${MPSTAT_INTERVAL:=2}
mpstat -P ${ENVOY_CPU_SET} $MPSTAT_INTERVAL `expr $LOAD_DURATION / $MPSTAT_INTERVAL` > ${BASE_DIR}/mpstat.txt &

mkdir -p $BASE_DIR
if [ $LOAD_CLIENT = "nighthawk" ]; then
    bash -x ./nighthawk-client.sh
elif [ $LOAD_CLIENT = "fortio" ]; then
    bash -x ./fortio_client.sh
elif [ $LOAD_CLIENT = "wrk" ]; then
    bash -x ./wrk.sh
elif [ $LOAD_CLIENT = "wrk2" ]; then
    bash -x ./wrk.sh
else
    echo "Not supported load client: $LOAD_CLIENT"
    exit 1
fi

SUMMARY_FILE=$BASE_DIR/summary.txt
touch $SUMMARY_FILE
echo "# Envoy enviroment as below" >> $SUMMARY_FILE
echo "ENVOY_CPU_SET=${ENVOY_CPU_SET:=13-17}" >> $SUMMARY_FILE
echo "ENVOY_CONCURRENCY=${ENVOY_CONCURRENCY:=4}" >> $SUMMARY_FILE
echo "ENVOY_BIN=${ENVOY_BIN:=/home/hejiexu/go/src/github.com/envoyproxy/envoy/bazel-bin//source/exe/envoy-static}" >> $SUMMARY_FILE
echo "ENVOY_CONFIG=${ENVOY_CONFIG:=}" >> $SUMMARY_FILE

echo ""

echo "# Fortio server enviroment as below" >> $SUMMARY_FILE
echo "BACKEND_CPU_SET=${BACKEND_CPU_SET:=50-59}" >> $SUMMARY_FILE

echo ""

echo "# Nighthawk client enviroment as below" >> $SUMMARY_FILE
echo "LOAD_CPU_SET=${LOAD_CPU_SET:=40-43}" >> $SUMMARY_FILE
echo "LOAD_CONNECTIONS=${LOAD_CONNECTIONS:=100}" >> $SUMMARY_FILE
echo "LOAD_RPS=${LOAD_RPS:=}" >> $SUMMARY_FILE
echo "LOAD_DURATION=${LOAD_DURATION:=120}" >> $SUMMARY_FILE
echo "LOAD_CONCURRENCY=${LOAD_CONCURRENCY:=4}" >> $SUMMARY_FILE
echo "LOAD_TARGET=${LOAD_TARGET:=http://127.0.0.1:13333/}" >> $SUMMARY_FILE
echo "LOAD_REQUEST_BODY_SIZE=${LOAD_REQUEST_BODY_SIZE:=0}" >> $SUMMARY_FILE
echo "LOAD_MAX_REQUEST_PER_CONNECTION=${LOAD_MAX_REQUEST_PER_CONNECTION:=4294937295}" >> $SUMMARY_FILE
echo "LOAD_TRANSPORT_OPT=${LOAD_TRANSPORT_OPT:=}" >> $SUMMARY_FILE
echo "LOAD_OTHER_OPT=${LOAD_OTHER_OPT}" >> $SUMMARY_FILE

# collect envoy stats
curl http://127.0.0.1:9901/stats > $BASE_DIR/envoy_stats.txt

bash ./cleanup.sh

# local cleanup
#source ./running_data.sh
#kill -9 $ENVOY_PID
#kill -9 $FORTIO_PID