# load nighthawk backend ng

# export TIMES=1
# export ENVOY_CPU_SET=32

# for conns in `seq 32 8 32`; do
#   export SUITE_DIR="1times-without-ht-poll-nosubmit/${conns}/iouring-load-nighthawk-back-nighthawk"
#   export LOAD_CONNECTIONS=${conns}
#   bash ./running_benchmark_suite_all_iouring-load-nighthawk-back-nighthawk.sh

# done
export PERF_ENABLED=0
export PERF_TOOL=perf
export LOAD_MODE=open
export PERF_LOAD=perf
export SUITE_BASE="tls-test-$(date +%s)"

# # HTTP1
# export SUITE_DIR=./$SUITE_BASE/http1
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http1.yaml
# export LOAD_TRANSPORT_OPT="--address-family v4 --protocol http1 --tls-context {\"common_tls_context\":{\"tls_params\":{\"tls_maximum_protocol_version\":\"TLSv1_3\"}}}"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# export SUITE_DIR=./$SUITE_BASE/http1-ecdsa
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http1-ecdsa.yaml
# export LOAD_TRANSPORT_OPT="--address-family v4 --protocol http1 --tls-context {\"common_tls_context\":{\"tls_params\":{\"tls_maximum_protocol_version\":\"TLSv1_3\"},\"alpn_protocols\":\"h2\"}}"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# export SUITE_DIR=./$SUITE_BASE/http1-cmb
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http1-cmb.yaml
# export LOAD_TRANSPORT_OPT="--protocol http1 --tls-context {\"common_tls_context\":{\"tls_params\":{\"tls_maximum_protocol_version\":\"TLSv1_3\"},\"alpn_protocols\":\"h2\"}}"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# export SUITE_DIR=./$SUITE_BASE/http1-cmb-ecdsa
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http1-cmb-ecdsa.yaml
# export LOAD_TRANSPORT_OPT="--protocol http1 --tls-context {\"common_tls_context\":{\"tls_params\":{\"tls_maximum_protocol_version\":\"TLSv1_3\"},\"alpn_protocols\":\"h2\"}}"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# export SUITE_DIR=./$SUITE_BASE/http1-qat
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http1-qat.yaml
# export LOAD_TRANSPORT_OPT="--protocol http1 --tls-context {\"common_tls_context\":{\"tls_params\":{\"tls_maximum_protocol_version\":\"TLSv1_3\"},\"alpn_protocols\":\"h2\"}}"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# # HTTP2
# export SUITE_DIR=./$SUITE_BASE/http2
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http2.yaml
# export LOAD_TRANSPORT_OPT="--protocol http2 --tls-context {\"common_tls_context\":{\"tls_params\":{\"tls_maximum_protocol_version\":\"TLSv1_3\"},\"alpn_protocols\":\"h2\"}}"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# export SUITE_DIR=./$SUITE_BASE/http2-ecdsa
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http2-ecdsa.yaml
# export LOAD_TRANSPORT_OPT="--protocol http2 --tls-context {\"common_tls_context\":{\"tls_params\":{\"tls_maximum_protocol_version\":\"TLSv1_3\"},\"alpn_protocols\":\"h2\"}}"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# export SUITE_DIR=./$SUITE_BASE/http2-cmb
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http2-cmb.yaml
# export LOAD_TRANSPORT_OPT="--protocol http2 --tls-context {\"common_tls_context\":{\"tls_params\":{\"tls_maximum_protocol_version\":\"TLSv1_3\"},\"alpn_protocols\":\"h2\"}}"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# export SUITE_DIR=./$SUITE_BASE/http2-cmb-ecdsa
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http2-cmb-ecdsa.yaml
# export LOAD_TRANSPORT_OPT="--protocol http2 --tls-context {\"common_tls_context\":{\"tls_params\":{\"tls_maximum_protocol_version\":\"TLSv1_3\"},\"alpn_protocols\":\"h2\"}}"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# export SUITE_DIR=./$SUITE_BASE/http2-qat
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http2-qat.yaml
# export LOAD_TRANSPORT_OPT="--protocol http2 --tls-context {\"common_tls_context\":{\"tls_params\":{\"tls_maximum_protocol_version\":\"TLSv1_3\"},\"alpn_protocols\":\"h2\"}}"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# HTTP3

# export SUITE_DIR=./$SUITE_BASE/http3
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http3.yaml
# export LOAD_TRANSPORT_OPT="--protocol http3 --address-family v4"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

export SUITE_DIR=./$SUITE_BASE/http3-ecdsa
export LOAD_TARGET=https://www.example.com:13333/
export ENVOY_CONFIG=./envoy-http3-ecdsa.yaml
export LOAD_TRANSPORT_OPT="--protocol http3  --address-family v4"
export LOAD_MAX_REQUEST_PER_CONNECTION=1
# load ng backend fortio
bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# export SUITE_DIR=./$SUITE_BASE/http3-cmb
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http3-cmb.yaml
# export LOAD_TRANSPORT_OPT="--protocol http3"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# export SUITE_DIR=./$SUITE_BASE/http3-cmb-ecdsa
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http3-cmb-ecdsa.yaml
# export LOAD_TRANSPORT_OPT="--protocol http3"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh

# export SUITE_DIR=./$SUITE_BASE/http3-qat
# export LOAD_TARGET=https://www.example.com:13333/
# export ENVOY_CONFIG=./envoy-http3-qat.yaml
# export LOAD_TRANSPORT_OPT="--protocol http3"
# export LOAD_MAX_REQUEST_PER_CONNECTION=1
# # load ng backend fortio
# bash ./running_benchmark_suite_all_load-nighthawk-back-fortio.sh



# # load fortio backend ng
# bash ./running_benchmark_suite_all_iouring-load-fortio-back-nighthawk.sh


# # load fortio beckend fortio
# bash ./running_benchmark_suite_all_iouring-load-fortio-back-fortio.sh

