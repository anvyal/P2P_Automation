$id = $ARGV[0];
system("adb -s $id logcat -c");
system("adb -s $id logcat -v threadtime | tee ./Logs/adb_$id.log");
