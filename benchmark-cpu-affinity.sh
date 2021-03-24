#!/bin/bash

set -e


export ENVOY_HOST=172.16.1.10
export FORTIO_HOST=172.16.1.11
export SSH_KEY=/home/hejiexu/openlab_key

RESULT_DIR='./result'

# the override data
RESULT_DIR='./result_remote_one_request_per_connection'

export CONCURRENCY=8
export DURATION=20
export RPS_START=1000
export RPS_INCREASE=1000
export RPS_END=35000
export REQUEST_BODY_SIZE=4096
export MAX_REQUEST_PER_CONNECTION=1


TRANSPORT_SOCKET='{name:"envoy.transport_sockets.tls",typed_config:{"@type":"type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.UpstreamTlsContext","common_tls_context":{"tls_certificates":[{"private_key":{"filename":"/home/hejiexu/cert/client-key.pem"},"certificate_chain":{"filename":"/home/hejiexu/cert/client.pem"}}]}}}'

# update benchmark script
echo "Update benchmark script to ENVOY and FORTIO host"
ssh -i $SSH_KEY hejiexu@$ENVOY_HOST "cd /home/hejiexu/cpu-affinity-benchmark; GIT_SSH_COMMAND='ssh -i /home/hejiexu/openlab_key' git pull origin master"
ssh -i $SSH_KEY hejiexu@$FORTIO_HOST "cd /home/hejiexu/cpu-affinity-benchmark; GIT_SSH_COMMAND='ssh -i /home/hejiexu/openlab_key' git pull origin master"

# Switch envoy branch to cpu_affinity one
#pushd /home/hejiexu/go/src/github.com/envoyproxy/envoy
ssh -i $SSH_KEY hejiexu@$ENVOY_HOST "cd /home/hejiexu/go/src/github.com/envoyproxy/envoy; git checkout cpu_affinity; bazel build --config=docker-clang-libc++ -c opt //source/exe:envoy-static"
#git checkout cpu_affinity_8
#bazel build --config=docker-clang-libc++ -c opt //source/exe:envoy-static
#popd

# separate cpuset between the client and envoy
export CPU_SET=18-27 # 8 cpu pinning
export ENVOY_CPU_SET=13-17
export ENVOY_CONCURRENCY=4

# test with cpu affinity and tls
export ENVOY_CONFIG=./envoy-http-with-tls.yaml
export BASE_DIR=$RESULT_DIR/envoy-with-cpu-affinity-with-tls
export TRANSPORT_OPT="--transport-socket $TRANSPORT_SOCKET"
echo "Begin to test cpu affinity with tls"
bash ./benchmark-envoy.sh


# test with cpu affinity but without tls
export ENVOY_CONFIG=./envoy-http.yaml
export BASE_DIR=$RESULT_DIR/envoy-with-cpu-affinity-without-tls
export TRANSPORT_OPT=
echo "Begin to test cpu affinity without tls"
bash ./benchmark-envoy.sh


# switch envoy branch to main
#pushd /home/hejiexu/go/src/github.com/envoyproxy/envoy
ssh -i $SSH_KEY hejiexu@$ENVOY_HOST "cd /home/hejiexu/go/src/github.com/envoyproxy/envoy; git checkout main; bazel build --config=docker-clang-libc++ -c opt //source/exe:envoy-static"
#git checkout main
#bazel build --config=docker-clang-libc++ -c opt //source/exe:envoy-static
#popd

# share same set of cpu between client and envoy
#export CPU_SET=14-25 # 8 cpu pinning
export ENVOY_CPU_SET=14-17

# test without cpu affinity and with tls
export ENVOY_CONFIG=./envoy-http-with-tls.yaml
export BASE_DIR=$RESULT_DIR/envoy-without-cpu-affinity-with-tls
export TRANSPORT_OPT="--transport-socket $TRANSPORT_SOCKET"
echo "Begin to test without cpu affinity with tls"
bash ./benchmark-envoy.sh

# test without cpu affinity and without tls
export ENVOY_CONFIG=./envoy-http.yaml
export BASE_DIR=$RESULT_DIR/envoy-without-cpu-affinity-without-tls
export TRANSPORT_OPT=
echo "Begin to test without cpu affinity without tls"
bash ./benchmark-envoy.sh