require devices;


$device1 = $ARGV[0];
$device2 = $ARGV[1];

devices::setup($device1);
devices::setup($device2);

devices::openWifiDirect($device1);
devices::openWifiDirect($device2);

#Get P2P Device ID of DUTs
$P2P_Device1 = `adb -s $device1 shell getprop P2PdeviceID`;
$P2P_Device2 = `adb -s $device2 shell getprop P2PdeviceID`;

#devices::searchDevices($device1);
#devices::searchDevices($device2);

devices::sendInvite( $device2, $P2P_Device1 );

devices::acceptInvite($device1);
sleep 10;
$ip1 = devices::startServer($device1);
$ip2 = devices::startServer($device2);

if ( ( $ip2 eq "localhost" ) )
{
	print "\n\tUnable to establish successfull Wifi-Direct Connection..\n";
	exit(0);
}
if ( $ip2 eq "localhost" )
{
	print "\n\tUnable to establish successfull Wifi-Direct Connection..\n";
	exit(0);
}

devices::videoStability( $device1, $ip2 );
sleep 15;
devices::videoStability( $device2, $ip1 );

