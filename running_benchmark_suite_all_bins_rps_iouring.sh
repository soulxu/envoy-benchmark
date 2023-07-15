set -e

# All test result is under $SUITE_DIR/result
export SUITE_DIR=./iouring-rps
echo $SUITE_DIR

export BIN_DIR="./bin"
export LOAD_CLIENT="nighthawk"
export BACK_SERVER="fortio"
export LOAD_TARGET="http://127.0.0.1:13333"
export LOAD_REQUEST_BODY_SIZE=4096
export LOAD_CONNECTIONS=32
export LOAD_DURATION=60

export LOAD_CPU_SET=3-9
export BACKEND_CPU_SET=10-22
export ENVOY_CPU_SET=1

export ENVOY_CONFIG=./envoy-iouring.yaml
export ENVOY_CONCURRENCY=1
export BACKEND_SERVER_PORT=13334

for bin in `ls $BIN_DIR`; do
    export ENVOY_BIN=$BIN_DIR/$bin
    mkdir -p $SUITE_DIR/${bin}
    echo -n "" > $SUITE_DIR/${bin}/test.result
    for rps in `seq 1000 100 2500`; do
        export BASE_DIR=$SUITE_DIR/$bin/$rps
        export LOAD_RPS=${rps}
        echo "Begin to test ${BASE_DIR}"
        bash ./benchmark-envoy.sh
        # catch the mean latency of "Request start to response end"
        echo "$rps `cat ${BASE_DIR}/nighthawk_result.result |grep "min:"| awk -F '|' 'NR == 3 {print $2}'`" >> $SUITE_DIR/$bin/test.result
    done
    sleep 3
done