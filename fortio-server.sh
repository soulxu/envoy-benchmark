#!/bin/bash

set -e
FORTIO_CPU_SET=${FORTIO_CPU_SET:=50-59}
echo "" > ./fortio.pid

taskset -c ${FORTIO_CPU_SET} fortio server > /dev/null 2>&1 &

echo "$!" >> ./fortio.pid