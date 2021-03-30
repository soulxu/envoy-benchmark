# remote cleanup
ENVOY_HOST=${ENVOY_HOST:=192.168.222.10}
FORTIO_HOST=${FORTIO_HOST:=192.168.222.11}
SSH_KEY=${SSH_KEY:=/home/hejiexu/openlab_key}
echo "Kill envoy on $ENVOY_HOST"
#ssh -i $SSH_KEY hejiexu@$ENVOY_HOST 'bash -c "cd /home/hejiexu/cpu-affinity-benchmark; kill -9 \`cat ./envoy.pid\`"'
ssh -i $SSH_KEY hejiexu@$ENVOY_HOST 'bash -c "cd /home/hejiexu/cpu-affinity-benchmark; kill -9 \`pgrep envoy\`"'
echo "Kill fortio on $FORTIO_HOST"
#ssh -i $SSH_KEY hejiexu@$FORTIO_HOST 'bash -c "cd /home/hejiexu/cpu-affinity-benchmark; kill -9 \`cat ./fortio.pid\`"'
ssh -i $SSH_KEY hejiexu@$FORTIO_HOST 'bash -c "cd /home/hejiexu/cpu-affinity-benchmark; kill -9 \`pgrep fortio\`"'

