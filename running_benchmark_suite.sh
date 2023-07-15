SUITE_DIR=./benchmark_connections_balance
RESULT_BASE_DIR=$SUITE_DIR/results

export ENVOY_CONFIG=./envoy-http.yaml

#export LOAD_CPU_SET=44-49
#export LOAD_CONNECTIONS=1
#export LOAD_REQUEST_BODY_SIZE=4096000000
#export LOAD_REQUEST_METHOD=POST
#export LOAD_RPS=1
#export LOAD_DURATION=120
#export LOAD_CONCURRENCY=1
#export LOAD_MAX_REQUEST_PER_CONNECTION=1


export LOAD_RPS=1000
export LOAD_DURATION=120
export LOAD_MAX_REQUEST_PER_CONNECTION=100
export ENVOY_CPU_SET=13-20
export ENVOY_CONCURRENCY=8

export BASE_DIR=$RESULT_BASE_DIR/1500_rps
echo "Begin to test $rps rps"
bash ./benchmark-envoy.sh

#for rps in `seq 500 100 2500`; do
#    export LOAD_RPS=$rps
#    export BASE_DIR=$RESULT_BASE_DIR/${rps}_rps
#    echo "Begin to test $rps rps"
#    bash ./benchmark-envoy.sh
#done