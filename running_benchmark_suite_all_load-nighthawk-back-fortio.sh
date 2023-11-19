set -e

# All test result is under $SUITE_DIR/result
export SUITE_DIR=${SUITE_DIR:=./1times-with-ht/iouring-load-nighthawk-back-fortio}
#export SUITE_DIR=./improve/iouring-load-nighthawk-back-fortio
echo $SUITE_DIR

export BIN_DIR="./bin"
export LOAD_CLIENT="nighthawk"
export BACK_SERVER="fortio"
export LOAD_TARGET=${LOAD_TARGET:="http://127.0.0.1:13333/?size=4096:100"}
export LOAD_REQUEST_BODY_SIZE=0
export LOAD_CONNECTIONS=2000
export LOAD_DURATION=120
export LOAD_MODE=closed
export LOAD_RPS=100

export LOAD_CPU_SET=0-55,112-167
export BACKEND_CPU_SET=168-223
export ENVOY_CPU_SET=56

export ENVOY_CONFIG=${ENVOY_CONFIG:=./envoy-iouring.yaml}
export ENVOY_CONCURRENCY=1
export BACKEND_SERVER_PORT=13334

export TIMES=5
export PERF_ENABLED=${PERF_ENABLED:=0}

for bin in `ls $BIN_DIR`; do
    export ENVOY_BIN=$BIN_DIR/$bin
    mkdir -p $SUITE_DIR/${bin}
    echo -n "" > $SUITE_DIR/${bin}/test.result
    echo -n "" > $SUITE_DIR/${bin}/test_99.result
    echo -n "" > $SUITE_DIR/${bin}/test_999.result
    echo -n "" > $SUITE_DIR/${bin}/test_throughput.result
    for concurrency in `seq 5 5 80`; do
        for i in `seq 1 1 $TIMES`; do
            export BASE_DIR=$SUITE_DIR/$bin/$concurrency/$i
            export LOAD_CONCURRENCY=${concurrency}
            echo "Begin to test ${BASE_DIR}"
            bash ./benchmark-envoy.sh
            # catch the mean latency of "Request start to response end"
            echo "$concurrency $i `cat ${BASE_DIR}/nighthawk_result.result |grep "min:"| awk -F '|' 'NR == 3 {print $2}'`" >> $SUITE_DIR/$bin/test.result
            echo "$concurrency $i `cat ${BASE_DIR}/nighthawk_result.result |grep "0.990"| awk 'NR == 3 {print $3 $4 $5}'`" >> $SUITE_DIR/$bin/test_99.result
            echo "$concurrency $i `cat ${BASE_DIR}/nighthawk_result.result |grep "0.999"| awk 'NR == 3 {print $3 $4 $5}'`" >> $SUITE_DIR/$bin/test_999.result
            echo "$concurrency $i `cat ${BASE_DIR}/nighthawk_result.result |grep "benchmark.http_2xx"` `cat ${BASE_DIR}/mpstat.txt |grep Average|awk 'NR == 2 {print $12}'`" >> $SUITE_DIR/$bin/test_throughput.result
        done
    done
    sleep 3
done

