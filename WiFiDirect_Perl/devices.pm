package devices;

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
#################################################################
#This Subroutine takes adb device id as parameter and
#
##################################################################
sub setup {

	#$id is the adb device id of device being setup
	my $id = $_[0];
	print("\nSetting Device: $id for test..\n");

	print("\n\tRooting and Remounting the $id device..\n");
	system("adb -s $id root");

	#sleep 5;
	system("adb -s $id remount");
	sleep 2;

	#install IsScreenUp apk
	system("adb -s $id install -rf IsScreenUp.apk");

	clearConfig($id);
	sleep 2;	
	
	print "\n\tDisable and Enable WiFi to ensure proper WiFi State on device..\n";
	system("adb -s $id shell svc wifi disable");

	
	sleep 2;
	system("adb -s $id shell svc wifi enable");

	#Open IsScreenUp apk
	system("adb -s $id shell am start -n com.qualcomm.isscreenup/.MainActivity");

	sleep 5;

}

sub clearConfig {

	my $id = $_[0];
	system("adb -s $id pull /data/misc/wifi/p2p_supplicant.conf ./Logs/p2p_supplicant_$id.conf");
	print("\n\Clearing REMEMBERED GROUPS from P2P config Files..\n");
	sleep(2);
	open FILE, "./Logs/p2p_supplicant_$id.conf" or die $!;
	open NEW,  ">./Logs/p2p_supplicant.conf"    or die $!;
	@conf = <FILE>;
	close(FILE);
	our @newConf, $i;

	foreach (@conf) {
		if ( $_ =~ "network={" ) {
			print "Hellow";
			last;
		}
		$newConf[i] = $_;
		print NEW $newConf[i];
		$i++;
	}

	foreach (@newConf) {
		print $_;
	}

	close(NEW);
	system("adb -s $id push ./Logs/p2p_supplicant.conf /data/misc/wifi/p2p_supplicant.conf");
}

sub openWifiDirect {
	my $id = $_[0];

	#Initiate a Home Keyevent
	system("adb -s $id shell input keyevent 3");
	system("adb -s $id shell am start -n com.android.settings/.Settings");
	system("adb -s $id push UIAutomator_4.4.2.jar /data/local/tmp/");
	system("adb -s $id shell uiautomator runtest UIAutomator_4.4.2.jar -c com.qualcomm.wifidirect.OpenWifiDirect");
}

sub acceptInvite {
	my $id = $_[0];
	system("adb -s $id shell uiautomator runtest UIAutomator_4.4.2.jar -c com.qualcomm.wifidirect.acceptInvite");
}

#adb shell setprop PeerID Android_7212

sub searchDevices {
	my $id = $_[0];
	system("adb -s $id shell uiautomator runtest UIAutomator_4.4.2.jar -c com.qualcomm.wifidirect.searchDevices");
}

sub sendInvite {
	my $id     = $_[0];
	my $peerID = $_[1];
	system("adb -s $id shell setprop PeerID $peerID");
	system("adb -s $id shell uiautomator runtest UIAutomator_4.4.2.jar -c com.qualcomm.wifidirect.sendInvite");
}
1;

