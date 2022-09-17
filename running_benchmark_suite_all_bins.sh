set -e

# All test result is under $SUITE_DIR/result
RESULT_BASE_DIR=$SUITE_DIR/result
mkdir -p $RESULT_BASE_DIR
echo $SUITE_DIR


for bin in `ls $BIN_DIR`; do
    export ENVOY_BIN=$BIN_DIR/$bin/envoy
    for i in `seq 1 1 $TEST_TIMES`; do
        export BASE_DIR=$RESULT_BASE_DIR/$bin/${i}
        echo "Begin to test ${BASE_DIR}"
        bash ./benchmark-envoy.sh
    done
    sleep 3
done
