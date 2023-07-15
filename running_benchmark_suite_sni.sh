SUITE_DIR=./benchmark_sni
RESULT_BASE_DIR=$SUITE_DIR/results

export ENVOY_CONFIG=./envoy-http.yaml

export LOAD_RPS=500
export LOAD_DURATION=120
export LOAD_MAX_REQUEST_PER_CONNECTION=100
export LOAD_TARGET="https://127.0.0.1:13333"
export ENVOY_CPU_SET=13-16
export ENVOY_CONCURRENCY=4
export ENVOY_CONFIG=./envoy-sni-http.yaml

# tls inspect new 
pushd .
cd ~/go/src/github.com/envoyproxy/envoy
git checkout poc_peek_data
bazel build //source/exe:envoy-static
popd 

export ENVOY_CONFIG=./envoy-sni-http.yaml
export BASE_DIR=$RESULT_BASE_DIR/1500_rps_read_tls_only
echo "Begin to test $rps rps"
bash ./benchmark-envoy.sh

# tls + http inspect new
export ENVOY_CONFIG=./envoy-sni-http2.yaml
export BASE_DIR=$RESULT_BASE_DIR/1500_rps_read_http_and_tls
echo "Begin to test $rps rps"
bash ./benchmark-envoy.sh
#############################
# tls old
pushd .
cd ~/go/src/github.com/envoyproxy/envoy
git checkout main
bazel build //source/exe:envoy-static
popd 

export ENVOY_CONFIG=./envoy-sni-http.yaml
export BASE_DIR=$RESULT_BASE_DIR/1500_rps_peek_tls_only
echo "Begin to test $rps rps"
bash ./benchmark-envoy.sh

# tls + http inspect old
export ENVOY_CONFIG=./envoy-sni-http2.yaml
export BASE_DIR=$RESULT_BASE_DIR/1500_rps_peek_http_and_tls
echo "Begin to test $rps rps"
bash ./benchmark-envoy.sh

#for rps in `seq 500 100 2500`; do
#    export LOAD_RPS=$rps
#    export BASE_DIR=$RESULT_BASE_DIR/${rps}_rps
#    echo "Begin to test $rps rps"
#    bash ./benchmark-envoy.sh
#done