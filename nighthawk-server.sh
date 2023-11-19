NIGHTHAWK_SERVER=${NIGHTHAWK_SERVER:=/home/xhj/nighthawk/bazel-bin/nighthawk_test_server}

BASE_ID=`od -An -N4 -tu4 < /dev/urandom`

taskset -c $BACKEND_CPU_SET $NIGHTHAWK_SERVER --base-id $BASE_ID --config-path ./nighthawk-test-server.yaml > ./nighthawk_server.log 2>&1 &

echo "$!" > ./nighthawk_test_server.pid