
cpu_path="/sys/devices/system/cpu"

for c in `ls $cpu_path`; do
  governor_path=$cpu_path/$c/cpufreq/scaling_governor
  if [ -f $governor_path ]; then
    echo "setting cpu governor to $governor_path"
    echo "performance" > $cpu_path/$c/cpufreq/scaling_governor
  fi
done
