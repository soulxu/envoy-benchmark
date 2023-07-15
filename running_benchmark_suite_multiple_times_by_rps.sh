# The top level directory
export TOP_DIR=/home/hejiexu/cpu-affinity-benchmark/auto_reservation_size_test_tls_with_single_reservation

# create the directory
mkdir -p $TOP_DIR
# all the binarys are in here.
export BIN_DIR=${TOP_DIR}/bins
mkdir -p $BIN_DIR

###
# Build the binary and copy into the bins dir.
###

# pushd .

# cd /home/hejiexu/go/src/github.com/envoyproxy/envoy

# # # The base code
# git checkout base_12_6
# bazel build -c opt //source/exe:envoy-static
# echo "$BIN_DIR/envoy-base/"
# mkdir -p $BIN_DIR/envoy-base/
# cp ./bazel-bin/source/exe/envoy-static $BIN_DIR/envoy-base/envoy

# # # The auto reservation size
# # git checkout dynamic_less_reservation_based_buffer_12_6
# # bazel build -c opt //source/exe:envoy-static
# # mkdir -p $BIN_DIR/envoy-dynamic_less_reservation/
# # cp ./bazel-bin/source/exe/envoy-static $BIN_DIR/envoy-dynamic_less_reservation/envoy

# # The auto reservation size with preallocate slice
# # git checkout dynamic_less_reservation_12_6
# # bazel build -c opt //source/exe:envoy-static
# # mkdir -p $BIN_DIR/envoy-dynamic_less_reservation_12_6/
# # cp ./bazel-bin/source/exe/envoy-static $BIN_DIR/envoy-dynamic_less_reservation_12_6/envoy

# git checkout tls_transport_with_single_reservation
# bazel build -c opt //source/exe:envoy-static
# mkdir -p $BIN_DIR/envoy-tls_transport_with_single_reservation/
# cp ./bazel-bin/source/exe/envoy-static $BIN_DIR/envoy-tls_transport_with_single_reservation/envoy

# popd

###
# The test default parameters
###
export ENVOY_CONFIG="./envoy-http-with-tls.yaml"
export LOAD_TRANSPORT_OPT='--transport-socket {name:"envoy.transport_sockets.tls",typed_config:{"@type":"type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.UpstreamTlsContext","common_tls_context":{"tls_certificates":[{"private_key":{"filename":"/home/hejiexu/cert/client-key.pem"},"certificate_chain":{"filename":"/home/hejiexu/cert/client.pem"}}]}}}'
export LOAD_TARGET="https://127.0.0.1:13333"
export LOAD_RPS=500
export LOAD_CONNECTIONS=50 # http1
export LOAD_MAX_REQUEST_PER_CONNECTION=10 # http2
export LOAD_DURATION=30
export ENVOY_CPU_SET=5
export ENVOY_CONCURRENCY=1
export LOAD_CPU_SET=20,21,22,23
export BACKEND_CPU_SET=24,25,26,27,28,29,30
# Each test is running multiple times
export TEST_TIMES=10


###
# customer common parameters
###
export LOAD_MAX_REQUEST_PER_CONNECTION=250
export LOAD_CONNECTIONS=5

###
# Go through each variable value for http1
###

##
Test by body size
##
IFS=";"
for i in `echo "0;32;64;128;256;512"`; do
    export SUITE_DIR=${TOP_DIR}/$i
    export LOAD_REQUEST_BODY_SIZE=$(($i*1024))
    echo "Test body size ${LOAD_REQUEST_BODY_SIZE}" 
    export LOAD_REQUEST_METHOD=POST
    bash ./running_benchmark_suite_all_bins.sh
done



###
# Go through each variable value for http2
###

###
# Test by body size
###
export TOP_DIR=/home/hejiexu/cpu-affinity-benchmark/auto_reservation_size_test_tls_with_single_reservation_h2
mkdir -p $TOP_DIR
export LOAD_OTHER_OPT=--h2
IFS=";"
for i in `echo "0;32;64;128;256;512"`; do
    export SUITE_DIR=${TOP_DIR}/$i
    export LOAD_REQUEST_BODY_SIZE=$(($i*1024))
    echo "Test body size ${LOAD_REQUEST_BODY_SIZE}" 
    export LOAD_REQUEST_METHOD=POST
    bash ./running_benchmark_suite_all_bins.sh
done


###################################


# HTTP1 test by variable connections
# RPS 500
# connections 100


# export TOP_DIR=/home/hejiexu/cpu-affinity-benchmark/auto_reservation_size_test_by_connections_12_7

# mkdir -p $TOP_DIR

# cp -R /home/hejiexu/cpu-affinity-benchmark/auto_reservation_size_h2_test_by_body_size_12_7/bins $TOP_DIR

# export LOAD_CONNECTIONS=50
# export LOAD_REQUEST_BODY_SIZE=0
# export LOAD_REQUEST_METHOD=GET

# IFS=";"
# for i in `echo "10;50;100;150;200;250;300;350;400;450"`; do
#     export SUITE_DIR=${TOP_DIR}/$i
#     export LOAD_CONNECTIONS=$i
#     echo "Test connection number ${LOAD_CONNECTIONS}" 
#     bash ./running_benchmark_suite_auto_reservation_size_test.sh
# done


###################################


# HTTP2 test by variable bodys
# RPS 500
# connections 100

# sleep 5

# export TOP_DIR=/home/hejiexu/cpu-affinity-benchmark/auto_reservation_size_h2_test_by_body_size_12_7
# mkdir -p $TOP_DIR

# cp -R /home/hejiexu/cpu-affinity-benchmark/auto_reservation_size_h2_test_by_body_size_12_7/bins $TOP_DIR

# export LOAD_MAX_REQUEST_PER_CONNECTION=10
# #export LOAD_CONNECTIONS=50
# export LOAD_REQUEST_BODY_SIZE=0
# export LOAD_OTHER_OPT=--h2

# # "0;16;32;64;128;256;512;1024"
# IFS=";"
# for i in `echo "0;16;32;64;128;256;512;1024"`; do
#     export SUITE_DIR=${TOP_DIR}/$i
#     export LOAD_REQUEST_BODY_SIZE=$(($i*1024))
#     echo "Test body size ${LOAD_REQUEST_BODY_SIZE}" 
#     export LOAD_REQUEST_METHOD=POST
#     bash ./running_benchmark_suite_auto_reservation_size_test.sh
# done

###################################


# HTTP2 test by variable connections size
# RPS 500
# connections 100
# sleep5

# export TOP_DIR=/home/hejiexu/cpu-affinity-benchmark/auto_reservation_size_h2_test_by_connections_12_7

# mkdir -p $TOP_DIR

# cp -R /home/hejiexu/cpu-affinity-benchmark/auto_reservation_size_h2_test_by_body_size_12_7/bins $TOP_DIR

# export LOAD_REQUEST_BODY_SIZE=0
# export LOAD_OTHER_OPT=--h2
# export LOAD_REQUEST_METHOD=GET

# IFS=";"
# for i in `echo "10;50;100;150;200;250;300;350;400;450"`; do
#     export SUITE_DIR=${TOP_DIR}/$i
#     export LOAD_MAX_REQUEST_PER_CONNECTION=$i
#     echo "Test connection number ${LOAD_MAX_REQUEST_PER_CONNECTION}" 
#     bash ./running_benchmark_suite_auto_reservation_size_test.sh
# done