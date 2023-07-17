set -e

# All test result is under $SUITE_DIR/result
export SUITE_DIR=./iouring-rps-perf
echo $SUITE_DIR

export BIN_DIR="./bin-debug"
export LOAD_CLIENT="nighthawk"
export BACK_SERVER="fortio"
export LOAD_TARGET="http://127.0.0.1:13333"
export LOAD_REQUEST_BODY_SIZE=4096
export LOAD_CONNECTIONS=32
export LOAD_DURATION=60
export LOAD_MODE=open

export LOAD_CPU_SET=3-9
export BACKEND_CPU_SET=10-22
export ENVOY_CPU_SET=1

export ENVOY_CONFIG=./envoy-iouring.yaml
export ENVOY_CONCURRENCY=1
export BACKEND_SERVER_PORT=13334

export TIMES=1

export PERF_ENABLED=1
export PERF_TOOL=perf

for bin in `ls $BIN_DIR`; do
    export ENVOY_BIN=$BIN_DIR/$bin
    mkdir -p $SUITE_DIR/${bin}
    echo -n "" > $SUITE_DIR/${bin}/test.result
    echo -n "" > $SUITE_DIR/${bin}/test_99.result
    echo -n "" > $SUITE_DIR/${bin}/test_999.result
    for rps in `seq 300 200 300`; do
        for i in `seq 1 1 $TIMES`; do
            export BASE_DIR=$SUITE_DIR/$bin/$rps/$i
            export LOAD_RPS=${rps}
            echo "Begin to test ${BASE_DIR}"
            bash ./benchmark-envoy.sh
            sleep 3
            sudo chown hejiexu:hejiexu $BASE_DIR/perf.data
            perf script --input=$BASE_DIR/perf.data | benchmark_tools/FlameGraph/stackcollapse-perf.pl > out.perf-folded
            benchmark_tools/FlameGraph/flamegraph.pl out.perf-folded > $BASE_DIR/perf.svg
            # pprof -output $BASE_DIR/envoy.png -png $ENVOY_BIN $BASE_DIR/envoy.cpuprof
            # catch the mean latency of "Request start to response end"
            echo "$rps $i `cat ${BASE_DIR}/nighthawk_result.result |grep "min:"| awk -F '|' 'NR == 3 {print $2}'`" >> $SUITE_DIR/$bin/test.result
            echo "$rps $i `cat ${BASE_DIR}/nighthawk_result.result |grep "0.990"| awk 'NR == 3 {print $3 $4 $5}'`" >> $SUITE_DIR/$bin/test_99.result
            echo "$rps $i `cat ${BASE_DIR}/nighthawk_result.result |grep "0.999"| awk 'NR == 3 {print $3 $4 $5}'`" >> $SUITE_DIR/$bin/test_999.result
        done
    done
    sleep 3
done