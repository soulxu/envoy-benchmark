SUITE_DIR=./example_benchmark_suite
RESULT_BASE_DIR=$SUITE_DIR/results

export ENVOY_CONFIG=./envoy-http.yaml

for rps in `seq 5000 5000 40000`; do
    export NIGHTHAWK_RPS=$rps
    export BASE_DIR=$RESULT_BASE_DIR/${rps}_rps
    echo "Begin to test $rps rps"
    bash ./benchmark-envoy.sh
done