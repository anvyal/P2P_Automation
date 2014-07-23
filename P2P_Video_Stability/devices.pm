package devices;

$deviceCheck = 1;

sub detect {

	@devices = `adb devices`;

	#print "Devices: @devices";
	print("\nDetecting the devices connected to this PC...\n");
	foreach (@devices) {

		#print "line $i: ".$_;
		if (/List of devices attached/) {

		}
		else {
			if ( (/(\w+)\s+(device)/) ) {
				push( @device_id, $1 );
			}
		}

	}
	if ( $deviceCheck == 1 ) {
		if ( $#device_id < 1 ) {
			print "\n@devices";
			print "FATAL ERROR::Unable to detect 2 devices Connected to the PC, please check device physical connection/state..!!\n\n";
			print "\n\nEnter any key to Continue..";
			<>;
			exit(0);
		}
	}
	sleep 1;
}

sub display {
	print "\n\tDevices Connected to this PC: \n";
	$index = 1;
	foreach (@device_id) {
		print "\tDevice $index: $_\n";
		$index++;
	}
}

sub genHash {
	my $id = $_[0];

	print "\nIn genHash() $id\n";

	%device = (
		"adb"    => "adb_$id",
		"kernel" => "kernel_$id",
		"video"  => "video_$id",
		"id"     => "$id"
	);

	while ( ( $key, $value ) = each(%device) ) {
		print $key. ", " . $value . "\n";
	}
	print "\n";
	return \%device;
}

#################################################################
#This Subroutine takes adb device id as parameter and
#
##################################################################
sub setup {

	#$id is the adb device id of device being setup
	my $id = $_[0];
	print("\nSetting Device: $id for test..\n");

	print("\n\tRooting and Remounting the $id device..\n\n");
	system("adb -s $id root");

	sleep 5;
	system("adb -s $id remount");
	sleep 2;

	#install IsScreenUp apk
	print("\n\nSetting screen timeout to 30 mins..\n");
	system("adb -s $id install -rf IsScreenUp.apk");

	clearConfig($id);
	sleep 2;

	reEnableWiFi($id);

	#Open IsScreenUp apk
	system("adb -s $id shell am start -n com.qualcomm.isscreenup/.MainActivity");

	sleep 5;

}

sub startServer {
	my $id = $_[0];

	#install IsScreenUp apk
	print("\n\nInstalling KWS Server on device: $id..\n");
	system("adb -s $id install -rf kws_server.apk");
	sleep 2;
	print("\n\tStarting KWS Server on device: $id..");
	system("adb -s $id shell am start -n org.xeustechnologies.android.kws/.ui.KwsActivity");
	sleep 2;
	system("pwd");
	system("mkdir ./Logs/Conf/");
	system("adb -s $id shell uiautomator runtest UIAutomator_4.4.2.jar -c com.qualcomm.httpserver.startServer | tee ./Logs/Conf/ServerLog_$id.log");

	#system("adb -s $id pull /sdcard/ServerLog_$id.log /Logs/");
	$IP = parseIP($id);
	print "\nIP Fetched: $IP";
	return $IP;
}
sub parseIP {
	my $id = $_[0];
	open SLOG, "./Logs/Conf/ServerLog_$id.log" or die $!;
	@log = <SLOG>;
	close SLOG;

	foreach (@log) {
		if ( $_ =~ /Host {([\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3})}/ ) {
			return $1;
			$foundIP = 1;
		}
	}
	if ( $foundIP == 0 ) {
		print "\n\tUnable to get a valid IP, check if WiFi Direct connection is proper !!";
		return 0;
	}
}

sub reEnableWiFi {
	my $id = $_[0];
	print "\n\tDisable and Enable WiFi to ensure proper WiFi State on device..\n";
	system("adb -s $id shell svc wifi disable");

	sleep 2;
	system("adb -s $id shell svc wifi enable");
}

sub clearConfig {

	my $id = $_[0];
	system("mkdir ./Logs/Conf/");
	system("adb -s $id pull /data/misc/wifi/p2p_supplicant.conf ./Logs/Conf/p2p_supplicant_$id.conf");
	system("adb -s $id pull /data/misc/wifi/wpa_supplicant.conf ./Logs/Conf/wpa_supplicant_$id.conf");
	print("\n\Clearing REMEMBERED GROUPS from P2P config Files..\n");
	sleep(2);
	open P2PFILE, "./Logs/Conf/p2p_supplicant_$id.conf" or warn $!;
	open WFILE,   "./Logs/Conf/wpa_supplicant_$id.conf" or warn $!;
	open P2PNEW,  ">./Logs/Conf/p2p_supplicant.conf"    or die $!;
	open WNEW,    ">./Logs/Conf/wpa_supplicant.conf"    or die $!;
	@p2pConf = <P2PFILE>;
	@wconf   = <WFILE>;
	close(P2PFILE);
	close(WFILE);
	our @newP2pConf, $i = 0;
	our @newWConf;

	foreach (@p2pConf) {
		if ( $_ =~ "network={" ) {
			print "\nSucceeded resetting P2Pconfig File..\n";
			last;
		}
		$newConf[i] = $_;
		print P2PNEW $newConf[i];
		$i++;
	}

	$i = 0;

	foreach (@wconf) {
		if ( $_ =~ "network={" ) {
			print "\nSucceeded resetting WiFiConfig File..\n";
			last;
		}
		$newWConf[i] = $_;
		print WNEW $newWConf[i];
		$i++;
	}

	foreach (@newP2pConf) {
		print $_;
	}

	foreach (@newWConf) {
		print $_;
	}

	close(P2PNEW);
	close(WNEW);
	system("adb -s $id push ./Logs/Conf/p2p_supplicant.conf /data/misc/wifi/p2p_supplicant.conf");
	system("adb -s $id push ./Logs/Conf/wpa_supplicant.conf /data/misc/wifi/wpa_supplicant.conf");
}

sub openWifiDirect {
	my $id = $_[0];

	#Initiate a Home Keyevent
	system("adb -s $id shell input keyevent 3");

	print("\n\tOpening WiFi Direct on device: $id..\n");

	#Open Device Settings
	system("adb -s $id shell am start -n com.android.settings/.Settings");

	#Run OpenWifiDirect UIAS
	system("adb -s $id push UIAutomator_4.4.2.jar /data/local/tmp/");
	system("adb -s $id shell uiautomator runtest UIAutomator_4.4.2.jar -c com.qualcomm.wifidirect.OpenWifiDirect");
}

sub acceptInvite {
	my $id = $_[0];
	system("adb -s $id shell uiautomator runtest UIAutomator_4.4.2.jar -c com.qualcomm.wifidirect.acceptInvite");
}

sub searchDevices {
	my $id = $_[0];
	system("adb -s $id shell uiautomator runtest UIAutomator_4.4.2.jar -c com.qualcomm.wifidirect.searchDevices");
}

sub isConnected {
	my $id = $_[0];
	system("adb -s $id shell uiautomator runtest UIAutomator_4.4.2.jar -c com.qualcomm.wifidirect.isConnected");
}

#adb shell setprop PeerID Android_7212

sub searchDevices {
	my $id = $_[0];
	print "\n\tSearching for Peer devices on $id..\n";
	system("adb -s $id shell uiautomator runtest UIAutomator_4.4.2.jar -c com.qualcomm.wifidirect.searchDevices");
}

sub sendInvite {
	my $id     = $_[0];
	my $peerID = $_[1];
	print "\n\tSending Peer Invitation to device: $id..\n";
	system("adb -s $id shell setprop PeerID $peerID");
	system("adb -s $id shell uiautomator runtest UIAutomator_4.4.2.jar -c com.qualcomm.wifidirect.sendInvite");
}

sub videoStability {

	my $deviceRef = $_[0];
	my %device    = %{$deviceRef};
	my $ip        = $_[1];
	$| = 1;

	startProcess( "$device{'video'}", "perl videoStability.pl $device{'id'} $ip" );

}

sub getTime {
	@months   = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
	@weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);

	( $second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings ) = localtime();
	$year = 1900 + $yearOffset;
	$Time = "$hour-$minute-$second-$weekDays[$dayOfWeek]-$months[$month]-$dayOfMonth-$year";

	#print "\n\n$Time";
	return $Time;
}

sub startLogging {

	my $deviceRef = $_[0];
	$Time = $_[1];
	my %device = %{$deviceRef};
	$| = 1;

	print "\nStarting Logs on device: $device{'id'}... \n";

	startProcess( "$device{'adb'}", "perl adbLogs.pl $device{'id'} $Time" );
	sleep 2;

	startProcess( "$device{'kernel'}", "perl dmsgLogs.pl $device{'id'} $Time" );
}

sub startProcess {
	my $title = $_[0];
	my $cmd   = $_[1];
	system("start \"$title\" /MIN cmd.exe /k $cmd");
}

sub killProcess {
	$title = $_[0];
	print("taskkill /FI \"WINDOWTITLE eq $title\*\"");
	system("taskkill /FI \"WINDOWTITLE eq $title\*\"");
}

sub connectP2PWiFi {
	$clientRef = shift;

	#Open Device Settings
	system("adb -s $clientRef->{id} shell am start -n com.android.settings/.Settings");
	print "\n\$clientRef->{ssid} = $clientRef->{ssid}";
	print "\n\$clientRef->{psk} = $clientRef->{psk}";
	print "\n\tConnecting device $clientRef->{id} to existing P2P..\n";
	system("adb -s $clientRef->{id} shell setprop ssid $clientRef->{ssid}");
	system("adb -s $clientRef->{id} shell setprop clientPSK $clientRef->{psk}");
	system("adb -s $clientRef->{id} push UIAutomator_4.4.2.jar /data/local/tmp/");
	system("adb -s $clientRef->{id} shell uiautomator runtest UIAutomator_4.4.2.jar -c com.qualcomm.wifidirect.connectP2PWiFi");
}

sub getGoID {
	$temp       = $_[0];
	@deviceHash = @$temp;
	for ( $j = 0 ; $j <= $#deviceHash ; $j++ ) {
		if ( devices::isGO( $deviceHash[$j]->{'id'} ) ) {
			return "$deviceHash[$j]->{'id'}";
		}
	}
}

sub isGO {
	$deviceID = $_[0];
	$out      = `adb -s $deviceID shell ifconfig p2p0`;
	if ( $out =~ /ip ([\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3})/ ) {
		$ip = $1;
		if ( $ip eq "192.168.49.1" ) {
			return 1;
		}
		else { return 0; }
	}
}

sub getPSK {
	my $id = $_[0];
	system("adb -s $id pull /data/misc/wifi/p2p_supplicant.conf ./Logs/p2p_supplicant_$id.conf");
	print("\n\Getting PSK from client\n");
	sleep(2);
	open P2PFILE, "./Logs/p2p_supplicant_$id.conf" or warn $!;
	@p2pConf = <P2PFILE>;
	close(P2PFILE);

	foreach (@p2pConf) {
		if ( $_ =~ /ssid=\"([\w|\-]*)\"/ ) {
			print "\nssid is $1\n";
			$param{ssid} = $1;
		}
		if ( $_ =~ /psk=([\w]*)/ ) {
			print "\nPSK is $1\n";
			$param{psk} = $1;
			last;
		}

	}
	return \%param;
}

1;

