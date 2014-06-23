use devices;
devices::detect();
devices::display();
	$| = 0;

print "\nPlease enter device1 id:";
$device1 = <>;
chomp($device1);

print "\nPlease enter device2 id:";
$device2 = <>;
chomp($device2);

system("mkdir Logs");

system("perl WiFi_Direct.pl $device1 $device2 | tee Logs/stdout.log");
