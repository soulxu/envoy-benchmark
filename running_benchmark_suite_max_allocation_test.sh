# pushd .

# cd /home/hejiexu/go/src/github.com/envoyproxy/envoy
# git checkout managed_storage_optimize_with_cache_count
# bazel build -c opt //source/exe:envoy-static
# sudo cp ./bazel-bin/source/exe/envoy-static ~/cpu-affinity-benchmark/benchmark_max_memory_allocation/envoy-managed_storage_optimize_with_cache_count

# cd /home/hejiexu/go/src/github.com/envoyproxy/envoy
# git checkout base_with_cache_count
# bazel build -c opt //source/exe:envoy-static
# sudo cp ./bazel-bin/source/exe/envoy-static ~/cpu-affinity-benchmark/benchmark_max_memory_allocation/envoy-base_with_cache_count

# popd


export ENVOY_CONFIG=./envoy-http.yaml

export LOAD_REQUEST_BODY_SIZE=${LOAD_REQUEST_BODY_SIZE:=0}
export LOAD_REQUEST_METHOD=${LOAD_REQUEST_METHOD:=GET}
export LOAD_RPS=500
export LOAD_DURATION=60
#export LOAD_CONNECTIONS=${LOAD_CONNECTIONS:=}
#export LOAD_MAX_REQUEST_PER_CONNECTION=${LOAD_MAX_REQUEST_PER_CONNECTION:=}
#export LOAD_MAX_REQUEST_PER_CONNECTION=10
#export LOAD_TARGET="http://127.0.0.1:13333"
export ENVOY_CPU_SET=15
export ENVOY_CONCURRENCY=1
export ENVOY_CONFIG=./envoy-http.yaml
export LOAD_CPU_SET=20,21,22,23
export BACKEND_CPU_SET=24,25,26,27,28,29,30,31
export LOAD_OTHER_OPT=${LOAD_OTHER_OPT:=}



# test max memory allocation by connections
# SUITE_DIR=${SUITE_DIR:=./benchmark_max_memory_allocation/max_memory_allocation_by_cons}
# RESULT_BASE_DIR=$SUITE_DIR/results

# mkdir -p $RESULT_BASE_DIR

# for cons in `seq 1 50 300`; do
    
#     export BASE_DIR=$RESULT_BASE_DIR/$cons/managed_storage
#     export LOAD_CONNECTIONS=$cons
#     echo "Begin to test managed_storage"
#     bash ./benchmark-envoy.sh
# done


# test max memory allocation by body size
export LOAD_CONNECTIONS=50
SUITE_DIR=./benchmark_max_memory_allocation/max_memory_allocation_by_body_size
RESULT_BASE_DIR=$SUITE_DIR/results
mkdir -p $RESULT_BASE_DIR
export ENVOY_BIN=./benchmark_max_memory_allocation/envoy-managed_storage_optimize_with_cache_count

# for body_size in 1024 10240 20480 40960 81920 524288 1048576 2097152; do
#     export BASE_DIR=$RESULT_BASE_DIR/$body_size/managed_storage
#     export LOAD_REQUEST_BODY_SIZE=$body_size
#     echo "Begin to test managed_storage $body_size"
#     bash ./benchmark-envoy.sh
# done

# # 1024 10240 20480 40960 81920 524288 1048576 2097152
# export ENVOY_BIN=./benchmark_max_memory_allocation/envoy-base_with_cache_count
# for body_size in 1024 10240 20480 40960 81920 524288 1048576 2097152; do
#     export BASE_DIR=$RESULT_BASE_DIR/$body_size/base_with_cache_count
#     export LOAD_REQUEST_BODY_SIZE=$body_size
#     echo "Begin to test managed_storage $body_size"
#     bash ./benchmark-envoy.sh
# done

# export LOAD_CONNECTIONS=50
# SUITE_DIR=./benchmark_max_memory_allocation/max_memory_allocation_by_body_size
# RESULT_BASE_DIR=$SUITE_DIR/results
# mkdir -p $RESULT_BASE_DIR
# export ENVOY_BIN=./benchmark_max_memory_allocation/envoy-managed_storage_optimize_with_cache_count

for body_size in 196608; do
    export BASE_DIR=$RESULT_BASE_DIR/$body_size/managed_storage
    export LOAD_REQUEST_BODY_SIZE=$body_size
    echo "Begin to test managed_storage $body_size"
    bash ./benchmark-envoy.sh
done

# 1024 10240 20480 40960 81920 524288 1048576 2097152
export ENVOY_BIN=./benchmark_max_memory_allocation/envoy-base_with_cache_count
for body_size in 196608; do
    export BASE_DIR=$RESULT_BASE_DIR/$body_size/base_with_cache_count
    export LOAD_REQUEST_BODY_SIZE=$body_size
    echo "Begin to test managed_storage $body_size"
    bash ./benchmark-envoy.sh
done



# Test with 80kb payload and variable is connections.
# export LOAD_RPS=1000
# export LOAD_CONNECTIONS=50
# SUITE_DIR=${SUITE_DIR:=./benchmark_max_memory_allocation/max_memory_allocation_by_cons_with_80k_payload}
# RESULT_BASE_DIR=$SUITE_DIR/results
# mkdir -p $RESULT_BASE_DIR
# export ENVOY_BIN=./benchmark_max_memory_allocation/envoy-managed_storage_optimize_with_cache_count
# export LOAD_REQUEST_BODY_SIZE=81920

# for cons in 10 50 100 150 200; do
#     export BASE_DIR=$RESULT_BASE_DIR/$cons/managed_storage
#     export LOAD_CONNECTIONS=$cons
#     echo "Begin to test managed_storage $cons"
#     bash ./benchmark-envoy.sh
# done

# export ENVOY_BIN=./benchmark_max_memory_allocation/envoy-base_with_cache_count
# for cons in 10 50 100 150 200; do
#     export BASE_DIR=$RESULT_BASE_DIR/$cons/base_with_cache_count
#     export LOAD_CONNECTIONS=$cons
#     echo "Begin to test managed_storage $cons"
#     bash ./benchmark-envoy.sh
# done