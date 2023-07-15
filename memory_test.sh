pushd .

cd /home/hejiexu/go/src/github.com/envoyproxy/envoy
git checkout base
bazel build -c opt //source/exe:envoy-static
sudo cp ./bazel-bin/source/exe/envoy-static ~/cpu-affinity-benchmark/benchmark_memory_test/envoy-base

cd /home/hejiexu/go/src/github.com/envoyproxy/envoy
git checkout init_memory_first
bazel build -c opt //source/exe:envoy-static
sudo cp ./bazel-bin/source/exe/envoy-static ~/cpu-affinity-benchmark/benchmark_memory_test/envoy-init_memory_first

git checkout init_memory_first_1024
bazel build -c opt //source/exe:envoy-static
sudo cp ./bazel-bin/source/exe/envoy-static ~/cpu-affinity-benchmark/benchmark_memory_test/envoy-init_memory_first_1024

git checkout managed_storage
bazel build -c opt //source/exe:envoy-static
sudo cp ./bazel-bin/source/exe/envoy-static ~/cpu-affinity-benchmark/benchmark_memory_test/envoy-managed_storage

git checkout managed_storage_10240
bazel build -c opt //source/exe:envoy-static
sudo cp ./bazel-bin/source/exe/envoy-static ~/cpu-affinity-benchmark/benchmark_memory_test/envoy-managed_storage_10240

git checkout managed_storage_with_huge_page
bazel build -c opt //source/exe:envoy-static
sudo cp ./bazel-bin/source/exe/envoy-static ~/cpu-affinity-benchmark/benchmark_memory_test/envoy-managed_storage_with_huge_page

git checkout managed_storage_with_huge_page_10240
bazel build -c opt //source/exe:envoy-static
sudo cp ./bazel-bin/source/exe/envoy-static ~/cpu-affinity-benchmark/benchmark_memory_test/envoy-managed_storage_with_huge_page_10240
popd

export SUITE_DIR=./benchmark_memory_test_h1_less_cons_with_body

mkdir -p $SUITE_DIR/results
sudo cp ./benchmark_memory_test/envoy* $SUITE_DIR

export LOAD_CONNECTIONS=100
bash ./running_benchmark_suite_memory_test.sh

echo "====="

export SUITE_DIR=./benchmark_memory_test_h1_more_cons_with_body

mkdir -p $SUITE_DIR/results
sudo cp ./benchmark_memory_test/envoy* $SUITE_DIR

export LOAD_CONNECTIONS=2000
bash ./running_benchmark_suite_memory_test.sh

echo "====="

export SUITE_DIR=./benchmark_memory_test_h2_less_cons_with_body

mkdir -p $SUITE_DIR/results
sudo cp ./benchmark_memory_test/envoy* $SUITE_DIR

export LOAD_CONNECTIONS=2000
export LOAD_MAX_REQUEST_PER_CONNECTION=2000
export LOAD_OTHER_OPT=--h2
bash ./running_benchmark_suite_memory_test.sh

echo "====="

export SUITE_DIR=./benchmark_memory_test_h2_more_cons_with_body

mkdir -p $SUITE_DIR/results
sudo cp ./benchmark_memory_test/envoy* $SUITE_DIR

export LOAD_CONNECTIONS=2000
export LOAD_MAX_REQUEST_PER_CONNECTION=100
export LOAD_OTHER_OPT=--h2
bash ./running_benchmark_suite_memory_test.sh
