
use devices;
$| = 1;
devices::detect();

$device1 = $devices::device_id[0];
$device2 = $devices::device_id[1];

%deviceHash1 = devices::genHash($device1);
%deviceHash2 = devices::genHash($device2);

while (1)
{
	checkDisconnect();
	sleep(15);
}

sub checkDisconnect
{
	@out = `adb -s $device1 shell ping -c 1 192.168.49.1`;

	#@out = `adb shell ping -c 1 127.0.0.1`;
	#print @out;
	my $disconnect = 0;
	foreach (@out) {
		if ( $_ =~ /Network is unreachable/ )
		{
			print "\nCheckingP2P::P2P Network is Disconnected..\n";
			$disconnect++;
		}
	}
	if ( $disconnect == 0 )
	{
		print "\nCheckingP2P::P2P Network is Active\n";
	}
	else
	{
		killRun( \%deviceHash1 );
		killRun( \%deviceHash2 );
		system("perl WiFi_Direct.pl $device1 $device2 | tee Logs/stdout.log");
	}
}

sub killRun {
	my $deviceRef = $_[0];
	my %device    = %{$deviceRef};
	print("\n\nKilling all processes of $device1... \n\n");
	devices::killProcess( $device{'adb'} );
	devices::killProcess( $device{'kernel'} );
	devices::killProcess( $device{'video'} );

	print "\n\nRe-initiating the tests..\n\n";
}
