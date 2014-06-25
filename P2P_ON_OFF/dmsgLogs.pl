$id = $ARGV[0];
system("adb -s $id shell cat /proc/kmsg -v threadtime | tee ./Logs/kernel_$id.log");