#!/bin/bash

set -e
export FORTIO_CPU_SET=${FORTIO_CPU_SET:=30-33}

taskset -c ${FORTIO_CPU_SET} fortio server > ./fortio.log 2>&1 &

echo "$!" > ./fortio.pid