set -x
export LOAD_CPU_SET=35
#export LOAD_REQUEST_BODY_SIZE=524288
#export LOAD_REQUEST_METHOD=POST
export LOAD_RPS=500
export LOAD_DURATION=60
#export LOAD_CONNECTIONS=30
export LOAD_MAX_REQUEST_PER_CONNECTION=50
export LOAD_OTHER_OPT=--h2
bash ./nighthawk-client.sh