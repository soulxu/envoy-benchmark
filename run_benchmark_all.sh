# load nighthawk backend ng

# export TIMES=1
# export ENVOY_CPU_SET=32

# for conns in `seq 32 8 32`; do
#   export SUITE_DIR="1times-without-ht-poll-nosubmit/${conns}/iouring-load-nighthawk-back-nighthawk"
#   export LOAD_CONNECTIONS=${conns}
#   bash ./running_benchmark_suite_all_iouring-load-nighthawk-back-nighthawk.sh

# done
export PERF_ENABLED=1
export PERF_TOOL=perf

export SUITE_DIR=./tls-test/http3
export LOAD_TARGET=https://www.example.com:13333/
export ENVOY_CONFIG=./envoy-http3.yaml
export LOAD_TRANSPORT_OPT="--protocol http3"
export LOAD_MAX_REQUEST_PER_CONNECTION=1
# load ng backend fortio
bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

export SUITE_DIR=./tls-test/http3-cmb
export LOAD_TARGET=https://www.example.com:13333/
export ENVOY_CONFIG=./envoy-http3-cmb.yaml
export LOAD_TRANSPORT_OPT="--protocol http3"
export LOAD_MAX_REQUEST_PER_CONNECTION=1
# load ng backend fortio
bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

export SUITE_DIR=./tls-test/http3-qat
export LOAD_TARGET=https://www.example.com:13333/
export ENVOY_CONFIG=./envoy-http3-qat.yaml
export LOAD_TRANSPORT_OPT="--protocol http3"
export LOAD_MAX_REQUEST_PER_CONNECTION=1
# load ng backend fortio
bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh



# # load fortio backend ng
# bash ./running_benchmark_suite_all_iouring-load-fortio-back-nighthawk.sh


# # load fortio beckend fortio
# bash ./running_benchmark_suite_all_iouring-load-fortio-back-fortio.sh

