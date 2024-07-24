set -e

export SUITE_DIR=./envoy-vs-envoy-openssl-latency-$(date +%s)/http1
export LOAD_TARGET=https://127.0.0.1:13333/
export ENVOY_CONFIG=./envoy-http1.yaml

# All test result is under $SUITE_DIR/result
export BIN_DIR="./bin"
export LOAD_REQUEST_BODY_SIZE=0
export LOAD_CONNECTIONS=64
export LOAD_DURATION=60
export LOAD_MODE=open
export LOAD_OTHER_OPT="-k -keepalive=false"

export LOAD_CPU_SET=180-239
export BACKEND_CPU_SET=130-179
export ENVOY_CPU_SET=1

export ENVOY_CONCURRENCY=1
export BACKEND_SERVER_PORT=13334

###############################

echo $SUITE_DIR
export LOAD_CONNECTIONS=8
export TIMES=5
export LOAD_CLIENT="fortio"
export BACK_SERVER="fortio"
export PERF_ENABLED=0
export LOAD_RPS=800

for bin in `ls $BIN_DIR`; do
    export ENVOY_BIN=$BIN_DIR/$bin
    mkdir -p $SUITE_DIR/${bin}
    echo -n "" > $SUITE_DIR/${bin}/fortio_test.result
    for rps in `seq 100 300 1500`; do
        export LOAD_RPS=$rps
        echo "ENVOY_CONCURRENCY: $ENVOY_CONCURRENCY"
        echo "LOAD_CONNECTIONS: $LOAD_CONNECTIONS"
        echo "ENVOY_CPU_SET: $ENVOY_CPU_SET"
        for i in `seq 1 1 $TIMES`; do
            export BASE_DIR=$SUITE_DIR/$bin/$LOAD_RPS/$i
            echo "Begin to test ${BASE_DIR}"
            bash ./benchmark-envoy.sh
            # catch the mean latency of "Request start to response end"
            echo "$LOAD_RPS $i `cat ${BASE_DIR}/fortio_result.result |grep "All done"|awk '{print $8}'` `cat ${BASE_DIR}/fortio_result.result |grep "All done"|awk '{print $11}'` `cat ${BASE_DIR}/mpstat.txt |grep Average|awk 'NR == 2 {print $12}'`" >> $SUITE_DIR/$bin/fortio_test.result
        done
    done
    sleep 3
done
