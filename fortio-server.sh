#!/bin/bash

set -e
FORTIO_CPU_SET=${FORTIO_CPU_SET:=50-59}

taskset -c ${FORTIO_CPU_SET} fortio server &

echo FORTIO_PID=$! >> running_data.sh 