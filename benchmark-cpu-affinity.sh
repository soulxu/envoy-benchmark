#!/bin/bash

set -e

pushd /home/hejiexu/go/src/github.com/envoyproxy/envoy
git checkout cpu_affinity_8
bazel build --config=docker-clang-libc++ -c opt //source/exe:envoy-static
popd

RESULT_DIR='./result'

# the override data
RESULT_DIR='./result_8_client_cpus_8_cur_bodysize_512_with_noise_8_core'

export CONCURRENCY=8
export DURATION=120
export RPS_START=1000
export RPS_INCREASE=1000
export RPS_END=35000
export REQUEST_BODY_SIZE=512


# the debug ### override data
#RESULT_DIR='./tmp'
#export CPU_SET=40-47 # 8 cpu pinning
#export CONCURRENCY=8
#export DURATION=60
#export RPS_START=5000
#export RPS_INCREASE=5000
#export RPS_END=5000

TRANSPORT_SOCKET='{name:"envoy.transport_sockets.tls",typed_config:{"@type":"type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.UpstreamTlsContext","common_tls_context":{"tls_certificates":[{"private_key":{"filename":"/home/hejiexu/cert/client-key.pem"},"certificate_chain":{"filename":"/home/hejiexu/cert/client.pem"}}]}}}'

# separate cpuset between the client and envoy
export CPU_SET=18-27 # 8 cpu pinning
export ENVOY_CPU_SET=9-17
export ENVOY_CONCURRENCY=8

# test with cpu affinity and tls
export ENVOY_CONFIG=./envoy-http-with-tls.yaml
export BASE_DIR=$RESULT_DIR/envoy-with-cpu-affinity-with-tls
export TRANSPORT_OPT="--transport-socket $TRANSPORT_SOCKET"
bash ./benchmark-envoy.sh


# test with cpu affinity but without tls
export ENVOY_CONFIG=./envoy-http.yaml
export BASE_DIR=$RESULT_DIR/envoy-with-cpu-affinity-without-tls
export TRANSPORT_OPT=
bash ./benchmark-envoy.sh

pushd /home/hejiexu/go/src/github.com/envoyproxy/envoy
git checkout main
bazel build --config=docker-clang-libc++ -c opt //source/exe:envoy-static
popd

# share same set of cpu between client and envoy
#export CPU_SET=14-25 # 8 cpu pinning
export ENVOY_CPU_SET=10-17

# test without cpu affinity and with tls
export ENVOY_CONFIG=./envoy-http-with-tls.yaml
export BASE_DIR=$RESULT_DIR/envoy-without-cpu-affinity-with-tls
export TRANSPORT_OPT="--transport-socket $TRANSPORT_SOCKET"
bash ./benchmark-envoy.sh

# test without cpu affinity and without tls
export ENVOY_CONFIG=./envoy-http.yaml
export BASE_DIR=$RESULT_DIR/envoy-without-cpu-affinity-without-tls
export TRANSPORT_OPT=
bash ./benchmark-envoy.sh