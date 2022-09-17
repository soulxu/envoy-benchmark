set -e

SUITE_DIR=${SUITE_DIR:=/home/hejiexu/cpu-affinity-benchmark/auto_reservation_size_test}
RESULT_BASE_DIR=$SUITE_DIR/result
mkdir -p $RESULT_BASE_DIR
echo $SUITE_DIR

#cp -R $TOP_DIR/bins/* $SUITE_DIR/

# Times to test each binary
export TEST_TIMES=10

export ENVOY_CONFIG=${ENVOY_CONFIG:=./envoy-http.yaml}

export NIGHTHAWK_RPS=500
export NIGHTHAWK_DURATION=60
#export NIGHTHAWK_CONNECTIONS=${NIGHTHAWK_CONNECTIONS:=}
#export NIGHTHAWK_MAX_REQUEST_PER_CONNECTION=${NIGHTHAWK_MAX_REQUEST_PER_CONNECTION:=}
#export NIGHTHAWK_MAX_REQUEST_PER_CONNECTION=10
#export NIGHTHAWK_TARGET="http://127.0.0.1:13333"
export ENVOY_CPU_SET=5
export ENVOY_CONCURRENCY=1
export NIGHTHAWK_CPU_SET=20,21,22,23
export FORTIO_CPU_SET=24,25,26,27,28,29,30

# test http2, with 512kb body
#export NIGHTHAWK_OTHER_OPT=--h2
#export NIGHTHAWK_REQUEST_BODY_SIZE=512000
#export NIGHTHAWK_REQUEST_METHOD=POST
#export NIGHTHAWK_MAX_REQUEST_PER_CONNECTION=50


export ENVOY_BIN=$TOP_DIR/bins/envoy-base/envoy
for i in `seq 1 1 $TEST_TIMES`; do
    export BASE_DIR=$RESULT_BASE_DIR/base/${i}
    echo "Begin to test base ${i}"
    bash ./benchmark-envoy.sh
done


# sleep 5
# export ENVOY_BIN=$TOP_DIR/bins/envoy-dynamic_less_reservation/envoy
# for i in `seq 1 1 $TEST_TIMES`; do
#     export BASE_DIR=$RESULT_BASE_DIR/auto_reservation/${i}
#     echo "Begin to test auto reservation ${i}"
#     bash ./benchmark-envoy.sh
# done


sleep 5
export ENVOY_BIN=$TOP_DIR/bins/envoy-tls_transport_with_single_reservation/envoy
for i in `seq 1 1 $TEST_TIMES`; do
    export BASE_DIR=$RESULT_BASE_DIR/tls_transport_with_single_reservation/${i}
    echo "Begin to test auto reservation with preallocate slice"
    bash ./benchmark-envoy.sh
done


# sleep 5
# export ENVOY_BIN=$TOP_DIR/bins/envoy-dynamic_less_reservation_12_6/envoy
# for i in `seq 1 1 $TEST_TIMES`; do
#     export BASE_DIR=$RESULT_BASE_DIR/dynamic_less_reservation_transport_based/${i}
#     echo "Begin to test auto reservation with preallocate slice"
#     bash ./benchmark-envoy.sh
# done

