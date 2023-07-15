set -e

# All test result is under $SUITE_DIR/result
export SUITE_DIR=./single_test
echo $SUITE_DIR

export LOAD_CLIENT="wrk"
export BACK_SERVER="fortio"
export LOAD_TARGET="http://127.0.0.1:13333"
export LOAD_REQUEST_BODY_SIZE=4096
export LOAD_CONNECTIONS=32
export LOAD_DURATION=10
export LOAD_MODE=open

export LOAD_CPU_SET=3-9
export BACKEND_CPU_SET=10-22
export ENVOY_CPU_SET=1

export ENVOY_CONFIG=./envoy-iouring.yaml
export ENVOY_CONCURRENCY=1
export BACKEND_SERVER_PORT=13334

export BASE_DIR=$SUITE_DIR/
echo "Begin to test ${BASE_DIR}"
bash ./benchmark-envoy.sh