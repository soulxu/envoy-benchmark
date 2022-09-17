pushd .
mkdir buffer_test_results
cd /home/hejiexu/go/src/github.com/envoyproxy/envoy
git checkout benchmark_memory_test
bazel build //test/common/buffer:buffer_speed_test
bazel-bin/test/common/buffer/buffer_speed_test > buffer_test_results/envoy-benchmark_memory_test.txt

git checkout benchmark_memory_test_1024
bazel build //test/common/buffer:buffer_speed_test
bazel-bin/test/common/buffer/buffer_speed_test > buffer_test_results/envoy-benchmark_memory_test_1024.txt

git checkout benchmark_memory_test_1024_with_init
bazel build //test/common/buffer:buffer_speed_test
bazel-bin/test/common/buffer/buffer_speed_test > buffer_test_results/envoy-benchmark_memory_test_1024_with_init.txt

git checkout benchmark_memory_test_10240_with_init
bazel build //test/common/buffer:buffer_speed_test
bazel-bin/test/common/buffer/buffer_speed_test > buffer_test_results/envoy-benchmark_memory_test_10240_with_init.txt
popd