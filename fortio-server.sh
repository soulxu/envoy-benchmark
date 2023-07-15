#!/bin/bash

set -e
export BACKEND_CPU_SET=${BACKEND_CPU_SET:=30-33}
export BACKEND_SERVER_PORT=${BACKEND_SERVER_PORT:=13334}

FORTIO_SERVER=${FORTIO_SERVER:=~/go/bin/fortio}
taskset -c ${BACKEND_CPU_SET} $FORTIO_SERVER server -http-port ${BACKEND_SERVER_PORT} > ./fortio.log 2>&1 &

echo "$!" > ./fortio.pid