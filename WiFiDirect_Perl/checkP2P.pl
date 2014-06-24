
use devices;
$| = 1;
devices::detect();

$device1 = $devices::device_id[0];
$device2 = $devices::device_id[1];

while (1)
{
	checkDisconnect();
	sleep(15);
}

sub checkDisconnect
{
	@out = `adb -s $device1 shell ping -c 1 192.168.49.1`;

	#@out = `adb shell ping -c 1 127.0.0.1`;
	print @out;
	my $disconnect = 0;
	foreach (@out) {
		if ( $_ =~ /Network is unreachable/ )
		{
			print "\nP2P Network is Disconnected.. Re-initiating the tests\n";
			$disconnect++;
		}
	}
	if ( $disconnect == 0 )
	{
		print "\nP2P Network is Active\n";
	}
	else
	{
		killADB();
		system("perl WiFi_Direct.pl $device1 $device2 | tee Logs/stdout.log");
	}
}

sub killADB {
	print("\n\nKilling adb server using 'adb kill-server'... \n\n");
	system("adb kill-server");
	system("adb kill-server");
	sleep(2);
	system("adb kill-server");
	system("adb kill-server");
	sleep(2);
	system("adb kill-server");
	system("adb kill-server");
	sleep(2);
	system("adb kill-server");
	system("adb kill-server");
	sleep(2);
	system("adb kill-server");
	system("adb kill-server");
	sleep(2);
	system("adb kill-server");
	system("adb kill-server");
	sleep(2);
	system("adb kill-server");
	system("adb kill-server");
	sleep(3);

	system("taskkill /F /IM adb.exe");
	sleep(1);
	system("taskkill /F /IM adb.exe");
	sleep(1);
	system("taskkill /F /IM adb.exe");
	sleep(1);
	system("taskkill /F /IM adb.exe");
	sleep(1);
	sleep(40);
}
