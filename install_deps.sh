sudo apt-get install sysstat

# install fortio
mkdir -p ~/go/bin
export GOPATH=~/go/bin
go install fortio.org/fortio@latest

mkdir benchmark_tools
pushd benchmark_tools

# build wrk2
git clone https://github.com/giltene/wrk2.git
pushd wrk2
make
popd

# build wrk
git clone https://github.com/wg/wrk.git
pushd wrk
make
popd

popd