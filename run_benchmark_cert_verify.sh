export PERF_ENABLED=0
export PERF_TOOL=perf
export LOAD_MODE=open

export LOAD_OTHER_OPT="-cert ./client.pem -key ./client-key.pem -k -keepalive=false"

# HTTP1
export SUITE_DIR=./cert-verify-1/http1-software
export LOAD_TARGET=https://127.0.0.1:13333/
export ENVOY_CONFIG=./envoy-http1-cert-verify-software.yaml
export LOAD_MAX_REQUEST_PER_CONNECTION=1
# load ng backend fortio
bash ./running_benchmark_suite_all-load-fortio-back-fortio-cert-verify.sh

export SUITE_DIR=./cert-verify-1/http1-cmb
export LOAD_TARGET=https://127.0.0.1:13333/
export ENVOY_CONFIG=./envoy-http1-cert-verify-cmb.yaml
export LOAD_MAX_REQUEST_PER_CONNECTION=1
# load ng backend fortio
bash ./running_benchmark_suite_all-load-fortio-back-fortio-cert-verify.sh