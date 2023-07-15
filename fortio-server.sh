#!/bin/bash

set -e
export FORTIO_CPU_SET=${FORTIO_CPU_SET:=30-33}
export SERVER_PORT=${SERVER_PORT:=13334}

taskset -c ${FORTIO_CPU_SET} ~/go/bin/fortio server -http-port ${SERVER_PORT} > ./fortio.log 2>&1 &

echo "$!" > ./fortio.pid