$device1 = "338b9a8a";
$P2P_Device1 =`adb -s $device1 shell getprop P2PdeviceID`;
print $P2P_Device1;

