NIGHTHAWK_SERVER=${NIGHTHAWK_SERVER:=/home/xhj/nighthawk/bazel-bin/nighthawk_test_server}

taskset -c $BACKEND_CPU_SET $NIGHTHAWK_SERVER --config-path ./nighthawk-test-server.yaml > ./nighthawk_server.log 2>&1 &
