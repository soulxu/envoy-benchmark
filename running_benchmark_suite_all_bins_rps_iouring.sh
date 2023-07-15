set -e

# All test result is under $SUITE_DIR/result
export SUITE_DIR=./iouring-rps
RESULT_BASE_DIR=$SUITE_DIR/result
mkdir -p $RESULT_BASE_DIR
echo $SUITE_DIR

export BIN_DIR="./bin"
export LOAD_CLIENT="nighthawk"
export BACK_SERVER="fortio"
export NIGHTHAWK_TARGET="http://127.0.0.1:13333"
export NIGHTHAWK_REQUEST_BODY_SIZE=4096
export NIGHTHAWK_CONNECTIONS=32
export NIGHTHAWK_DURATION=60

export NIGHTHAWK_CPU_SET=3-9
export FORTIO_CPU_SET=10-22
export ENVOY_CPU_SET=1

export TEST_TIMES=1

export ENVOY_CONFIG=./envoy-iouring.yaml
export ENVOY_CONCURRENCY=1
export SERVER_PORT=13334

for bin in `ls $BIN_DIR`; do
    export ENVOY_BIN=$BIN_DIR/$bin
    for i in `seq 1 1 $TEST_TIMES`; do
        for rps in `seq 1000 500 8000`; do
            export BASE_DIR=$RESULT_BASE_DIR/$bin/${i}/$rps
            export NIGHTHAWK_RPS=${rps}
            echo "Begin to test ${BASE_DIR}"
            bash ./benchmark-envoy.sh
        done
    done
    sleep 3
done