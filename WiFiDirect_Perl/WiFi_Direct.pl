require devices;
$|       = 1;
$device1 = $ARGV[0];
$device2 = $ARGV[1];

%deviceHash1 = devices::genHash($device1);
%deviceHash2 = devices::genHash($device2);

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
devices::acceptInvite($device2);

devices::isConnected($device1);

system("adb -s $device1 push 17Again.mp4 /sdcard/");
system("adb -s $device2 push 17Again.mp4 /sdcard/");
sleep 3;

$ip1 = devices::startServer($device1);
$ip2 = devices::startServer($device2);

if ( $ip1 == 0 )
{
	print "\n\tUnable to establish successfull Wifi-Direct Connection..\n";
}
if ( $ip2 == 0 )
{
	print "\n\tUnable to establish successfull Wifi-Direct Connection..\n";
}
system( 1, "perl checkP2P.pl" );
system("start \"checkP2P\" /MIN cmd.exe /k perl checkP2P.pl");
devices::startLogging( $device1, \%deviceHash1 );
devices::startLogging( $device2, \%deviceHash2 );

devices::videoStability( $device1, $ip2, \%deviceHash1 );
sleep 15;
devices::videoStability( $device2, $ip1, \%deviceHash2 );

