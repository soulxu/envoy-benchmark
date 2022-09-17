# mkdir -p profile-bin
# pushd .
# cd /home/hejiexu/go/src/github.com/envoyproxy/envoy
# git checkout base
# bazel build --define tcmalloc=gperftools //source/exe:envoy-static
# popd

# cp /home/hejiexu/go/src/github.com/envoyproxy/envoy/bazel-bin//source/exe/envoy-static ./profile-bin/envoy-base

# pushd .
# cd /home/hejiexu/go/src/github.com/envoyproxy/envoy
# git checkout managed_storage
# bazel build --define tcmalloc=gperftools //source/exe:envoy-static
# popd
# cp /home/hejiexu/go/src/github.com/envoyproxy/envoy/bazel-bin//source/exe/envoy-static ./profile-bin/envoy-managed_storage

# pushd .
# cd /home/hejiexu/go/src/github.com/envoyproxy/envoy
# git checkout managed_storage_with_huge_page
# bazel build --define tcmalloc=gperftools //source/exe:envoy-static
# popd
# cp /home/hejiexu/go/src/github.com/envoyproxy/envoy/bazel-bin//source/exe/envoy-static ./profile-bin/envoy-managed_storage_with_huge_page


CPUPROFILE=/tmp/envoy.cpuprof ./profile-bin/envoy-base --config-path ~/cpu-affinity-benchmark/envoy-http.yaml --concurrency 1 &
bash ./fortio-server.sh
bash ./nighthawk-another-client.sh
bash ./cleanup.sh
sleep 2
pprof -png ./profile-bin/envoy-base /tmp/envoy.cpuprof
mv profile001.png profile-cpu-envoy-base-h1.png

# HEAPPROFILE=/tmp/envoy.heapprof ./profile-bin/envoy-base --config-path ~/cpu-affinity-benchmark/envoy-http.yaml --concurrency 1 &
# bash ./fortio-server.sh
# bash ./nighthawk-another-client.sh
# bash ./cleanup.sh
# sleep 2
# pprof -png ./profile-bin/envoy-base /tmp/envoy.heapprof
# mv profile001.png profile-heap-envoy-base.png


CPUPROFILE=/tmp/envoy.cpuprof ./profile-bin/envoy-managed_storage --config-path ~/cpu-affinity-benchmark/envoy-http.yaml --concurrency 1 &
bash ./fortio-server.sh
bash ./nighthawk-another-client.sh
bash ./cleanup.sh
sleep 2
pprof -png ./profile-bin/envoy-managed_storage /tmp/envoy.cpuprof
mv profile001.png profile-cpu-envoy-managed_storage-h1.png

# HEAPPROFILE=/tmp/envoy.heapprof ./profile-bin/envoy-managed_storage --config-path ~/cpu-affinity-benchmark/envoy-http.yaml --concurrency 1 &
# bash ./fortio-server.sh
# bash ./nighthawk-another-client.sh
# bash ./cleanup.sh
# sleep 2
# pprof -png ./profile-bin/envoy-managed_storage /tmp/envoy.heapprof
# mv profile001.png profile-heap-envoy-managed_storage.png


# CPUPROFILE=/tmp/envoy.cpuprof ./profile-bin/envoy-managed_storage_with_huge_page --config-path ~/cpu-affinity-benchmark/envoy-http.yaml --concurrency 1 &
# bash ./fortio-server.sh
# bash ./nighthawk-another-client.sh
# bash ./cleanup.sh
# sleep 2
# pprof -png ./profile-bin/envoy-managed_storage_with_huge_page /tmp/envoy.cpuprof
# mv profile001.png profile-cpu-envoy-managed_storage_with_huge_page.png

# HEAPPROFILE=/tmp/envoy.heapprof ./profile-bin/envoy-managed_storage_with_huge_page --config-path ~/cpu-affinity-benchmark/envoy-http.yaml --concurrency 1 &
# bash ./fortio-server.sh
# bash ./nighthawk-another-client.sh
# bash ./cleanup.sh
# sleep 2
# pprof -png ./profile-bin/envoy-managed_storage_with_huge_page /tmp/envoy.heapprof
# mv profile001.png profile-heap-envoy-managed_storage_with_huge_page.png


