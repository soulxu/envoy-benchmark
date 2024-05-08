pf_bdfs=`lspci -nd 8086:4940|awk '{print $1}'`
mode="asym;dc"

modprobe qat_4xxx
modprobe vfio-pci

for pf in $pf_bdfs; do
  echo "setup PF $pf"
  dev_path="/sys/bus/pci/devices/0000:$pf"
  echo 0 > "$dev_path/sriov_numvfs"
  echo down > "$dev_path/qat/state"
  echo $mode > "$dev_path/qat/cfg_services"
  echo up > "$dev_path/qat/state"
  echo 16 > "$dev_path/sriov_numvfs"
done
