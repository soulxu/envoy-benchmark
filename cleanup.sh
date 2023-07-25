# remote cleanup
ENVOY_HOST=${ENVOY_HOST:=192.168.222.10}
FORTIO_HOST=${FORTIO_HOST:=192.168.222.11}
SSH_KEY=${SSH_KEY:=/home/hejiexu/openlab_key}
BACK_SERVER=${BACK_SERVER:=fortio}
echo "Kill envoy on $ENVOY_HOST"
#ssh -i $SSH_KEY hejiexu@$ENVOY_HOST 'bash -c "cd /home/hejiexu/cpu-affinity-benchmark; kill -9 \`cat ./envoy.pid\`"'
#ssh -i $SSH_KEY hejiexu@$ENVOY_HOST 'bash -c "cd /home/hejiexu/cpu-affinity-benchmark; kill -9 \`pgrep envoy\`"'
kill -SIGINT `pgrep envoy`
if [ $PERF_ENABLED = 1 ]; then
    if [ $PERF_TOOL = perf ]; then
        sleep 3
        sudo kill -SIGINT `pgrep perf`
    fi
fi
echo "Kill backserver $BACK_SERVER on $FORTIO_HOST"
#ssh -i $SSH_KEY hejiexu@$FORTIO_HOST 'bash -c "cd /home/hejiexu/cpu-affinity-benchmark; kill -9 \`cat ./fortio.pid\`"'
#ssh -i $SSH_KEY hejiexu@$FORTIO_HOST 'bash -c "cd /home/hejiexu/cpu-affinity-benchmark; kill -9 \`pgrep fortio\`"'
if [ $BACK_SERVER = "nighthawk" ]; then
#kill -9 `pgrep nighthawk_test_server`
kill -9 `ps -ax|grep nighthawk_test_server`
elif [ $BACK_SERVER = "fortio" ]; then
kill -9 `pgrep fortio`
fi

