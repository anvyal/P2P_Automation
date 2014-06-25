require devices;
$| = 1;
$device1 = $ARGV[0];
$device2 = $ARGV[1];

devices::setup($device1);
devices::setup($device2);

open RLOG, ">./Logs/Result.log" or die $!;

for ($i=0;$i<=3000;$i++)
{
	$result = connectP2P();

	if($result == 1)
	{
		#Log Pass to RLOG
	}
	else if $result == 0)
	{
		#Log Fail to RLOG
	}
	disconnectP2P();
}

close RLOG;

sub connectP2P
{
	devices::clearConfig($device1);
	sleep 2;
	devices::EnableWiFi($device1);
	sleep 2;
	devices::clearConfig($device2);
	sleep 2;
	devices::EnableWiFi($device2);
	sleep 2;
	devices::openWifiDirect($device1);
	devices::openWifiDirect($device2);
			
	#Get P2P Device ID of DUTs
	$P2P_Device1 = `adb -s $device1 shell getprop P2PdeviceID`;
	$P2P_Device2 = `adb -s $device2 shell getprop P2PdeviceID`;
	
	devices::sendInvite( $device2, $P2P_Device1 );

	devices::acceptInvite($device1);

	devices::isConnected($device1);
}

sub disconnectP2P
{
devices::DisableWiFi($device1);
devices::DisableWiFi($device2);
}