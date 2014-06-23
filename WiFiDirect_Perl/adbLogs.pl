$id = $ARGV[0];
print("adb -s $id logcat -c");
system("adb -s $id logcat -c");
print("adb -s $id logcat -v threadtime | tee ./Logs/adb_$id.log");
system("adb -s $id logcat -v threadtime | tee ./Logs/adb_$id.log");
