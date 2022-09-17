set -e

export MULTIPLE_BASE=~/cpu-affinity-benchmark/benchmark_managed_memory_by_variable_body_size
RESULT_MULTIPLE_BASE_DIR=$MULTIPLE_BASE/results
mkdir -p $RESULT_MULTIPLE_BASE_DIR


# pushd .

# cd /home/hejiexu/go/src/github.com/envoyproxy/envoy
# git checkout base
# bazel build -c opt //source/exe:envoy-static
# echo "$MULTIPLE_BASE/envoy-base/"
# mkdir -p $MULTIPLE_BASE/bins/envoy-base/
# cp ./bazel-bin/source/exe/envoy-static $MULTIPLE_BASE/bins/envoy-base/envoy

# git checkout managed_storage
# bazel build -c opt //source/exe:envoy-static
# mkdir -p $MULTIPLE_BASE/bins/envoy-managed_storage/
# cp ./bazel-bin/source/exe/envoy-static $MULTIPLE_BASE/bins/envoy-managed_storage/envoy

# git checkout managed_storage_optimize
# bazel build -c opt //source/exe:envoy-static
# mkdir -p $MULTIPLE_BASE/bins/envoy-managed_storage_optimize/
# cp ./bazel-bin/source/exe/envoy-static $MULTIPLE_BASE/bins/envoy-managed_storage_optimize/envoy

# popd


for body_size in `seq 0 64 2048`; do
    body_size=$(($body_size*1024))
    echo "The body size is ${body_size}"
    export SUITE_DIR="${RESULT_MULTIPLE_BASE_DIR}/${body_size}"
    mkdir -p $SUITE_DIR
    export NIGHTHAWK_REQUEST_BODY_SIZE=$body_size
    bash ./running_benchmark_suite_memory_test.sh
done