set -e

SUITE_DIR=/home/hejiexu/cpu-affinity-benchmark/benchmark_less_reservation
RESULT_BASE_DIR=$SUITE_DIR/result
mkdir -p $RESULT_BASE_DIR

#cp -R $MULTIPLE_BASE/bins/* $SUITE_DIR/

# pushd .

# cd /home/hejiexu/go/src/github.com/envoyproxy/envoy
# git checkout base
# bazel build -c opt //source/exe:envoy-static
# echo "$SUITE_DIR/envoy-base/"
# mkdir -p $SUITE_DIR/envoy-base/
# cp ./bazel-bin/source/exe/envoy-static $SUITE_DIR/envoy-base/envoy

# git checkout less_reservation
# bazel build -c opt //source/exe:envoy-static
# mkdir -p $SUITE_DIR/envoy-less_reservation/
# cp ./bazel-bin/source/exe/envoy-static $SUITE_DIR/envoy-less_reservation/envoy

# popd


export ENVOY_CONFIG=./envoy-http.yaml

export NIGHTHAWK_RPS=500
export NIGHTHAWK_DURATION=60
#export NIGHTHAWK_CONNECTIONS=${NIGHTHAWK_CONNECTIONS:=}
#export NIGHTHAWK_MAX_REQUEST_PER_CONNECTION=${NIGHTHAWK_MAX_REQUEST_PER_CONNECTION:=}
#export NIGHTHAWK_MAX_REQUEST_PER_CONNECTION=10
#export NIGHTHAWK_TARGET="http://127.0.0.1:13333"
export ENVOY_CPU_SET=5
export ENVOY_CONCURRENCY=1
export ENVOY_CONFIG=./envoy-http.yaml
export NIGHTHAWK_CPU_SET=20,21,22,23
export FORTIO_CPU_SET=24,25,26,27,28,29,30

# test http2, with 512kb body
#export NIGHTHAWK_OTHER_OPT=--h2
export NIGHTHAWK_REQUEST_BODY_SIZE=1024
export NIGHTHAWK_REQUEST_METHOD=POST


export ENVOY_BIN=$SUITE_DIR/envoy-base/envoy
export BASE_DIR=$RESULT_BASE_DIR/base
echo "Begin to test base"
bash ./benchmark-envoy.sh

sleep 5
export ENVOY_BIN=$SUITE_DIR/envoy-less_reservation/envoy
export BASE_DIR=$RESULT_BASE_DIR/less_reservation
#export NIGHTHAWK_REQUEST_BODY_SIZE=0
#export NIGHTHAWK_REQUEST_METHOD=GET
echo "Begin to test managed_storage_optimize"
bash ./benchmark-envoy.sh


