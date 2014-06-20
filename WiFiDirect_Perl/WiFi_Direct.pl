require devices;
devices::detect();
devices::display();

$device1 = $devices::device_id[0];
$device2 = $devices::device_id[1];

devices::setup($device1);

#devices::setup($device2);

devices::openWifiDirect($device1);

#devices::openWifiDirect($device2);

#Get P2P Device ID of DUTs

$P2P_Device1 = `adb -s $device1 shell getprop P2PdeviceID`;
$P2P_Device2 = `adb -s $device2 shell getprop P2PdeviceID`;

#devices::searchDevices($device1);
#devices::searchDevices($device2);

#devices::sendInvite($device2, $P2P_Device1);

#$devices::acceptInvite($device1);
