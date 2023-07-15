set -e

# All test result is under $SUITE_DIR/result
RESULT_BASE_DIR=$SUITE_DIR/cores_result
mkdir -p $RESULT_BASE_DIR
echo $SUITE_DIR

export NUM_CORES=5
export ENVOY_CPU_SET=3-13
export ENVOY_BIN=./bin/envoy-static

for i in `seq 1 1 $NUM_CORES`; do
    export BASE_DIR=$RESULT_BASE_DIR/${i}
    export ENVOY_CONCURRENCY=$i
    echo "Begin to test ${BASE_DIR}"
    bash ./benchmark-envoy.sh
    sleep 3
done
