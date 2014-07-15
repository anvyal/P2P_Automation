#use strict;
require devices;
use Data::Dumper;
$| = 1;
our $one2many = $ARGV[0];
chomp($one2many);

our @deviceList;
our @deviceHash;

if ( $one2many == 1 ) {

	#get Device List
	for ( my $j = 0 ; $j < $#ARGV ; $j++ ) {
		if ( !( $j == 0 || $j == $#ARGV ) )    #Ignore first and last argument
		{
			$deviceList[ $j - 1 ] = $ARGV[$j];
		}
	}

	print "\nFollowing device IDs will be under test: \n";
	for ( my $j = 0 ; $j <= $#deviceList ; $j++ ) {
		print "\tDevice " . ( $j + 1 ) . ":" . $deviceList[$j] . "\n";
	}

	devices::killProcess("checkP2P_$deviceList[0]");

	#Gen deviceHash
	for ( my $j = 0 ; $j <= $#deviceList ; $j++ ) {
		push( @deviceHash, { %{ devices::genHash( $deviceList[$j] ) } } );
	}

	#Setup
	for ( $j = 0 ; $j <= $#deviceHash ; $j++ ) {
		devices::setup( $deviceHash[$j]->{'id'} );
	}

	#p2pSetup
	for ( $j = 0 ; $j <= $#deviceHash ; $j++ ) {
		print "\nTest:\n";

		#while ( ( $key, $value ) = each( %{ $deviceHash[$j] } ) ) {
		#	print $key. ", " . $value . "\n";
		#}

		devices::openWifiDirect( $deviceHash[$j]->{'id'} );

		#Adds an item to deviceHash
		$deviceHash[$j]->{'p2pid'} = `adb -s $deviceHash[$j]->{'id'} shell getprop P2PdeviceID`;
		if ( $j != 0 )
		{
			devices::searchDevices( $deviceHash[ $j - 1 ]->{'id'} );
			sleep(2);
			devices::sendInvite( $deviceHash[$j]->{'id'}, $deviceHash[ $j - 1 ]->{'p2pid'} );
			sleep(2);
			devices::acceptInvite( $deviceHash[ $j - 1 ]->{'id'} );
		}
	}

	#identify GO
	$goID = devices::getGoID( \@deviceHash );

	#identify client
	for ( $j = 0 ; $j <= 1 ; $j++ ) {
		if ( $deviceHash[$j]->{'id'} == $goID )
		{ }
		else
		{
			$clientID = $deviceHash[$j]->{'id'};
		}
	}

	#get client PSK
	$psk = devices::getPSK($clientID);

	for ( $j = 2 ; $j <= $#deviceHash ; $j++ ) {
		devices::connectP2PWiFi( $deviceHash[$j]->{'id'}, $goID, $psk );
	}

	#isConnected
	for ( $j = 0 ; $j <= $#deviceHash ; $j++ ) {

		my $temp = `adb -s $deviceHash[$j]->{'id'} shell ls /sdcard/17Again.mp4`;
		if ( $temp =~ /No such file or directory/ ) {
			system( 1, "adb -s $deviceHash[$j]->{'id'} push 17Again.mp4 /sdcard/" );
		}
		else {
			print "\nVideo File already exists in device: $deviceHash[$j]->{'id'}\n";
		}

		#print "\n$deviceHash[$j]->{'id'}: $deviceHash[$j]->{'p2pid'}\n";
		devices::isConnected( $deviceHash[$j]->{'id'} );

	}

	sleep 3;

	my $pid = fork();
	if ( not defined $pid ) {
		die 'resources not available';
	}
	elsif ( $pid == 0 ) {

		#CHILD
		#system("start \"wifiDirect\" /MIN cmd.exe /k sleep 5" );
		print("\nstart \"checkP2P_$deviceHash[0]->{'id'}\" perl.exe checkP2P.pl $one2many @deviceList 0\n");
		system( 1, "start \"checkP2P_$deviceHash[0]->{'id'}\" perl.exe checkP2P.pl $one2many @deviceList 0" );
		exit(0);
	}
	else {

		# PARENT
		for ( $j = 0 ; $j <= $#deviceHash ; $j++ ) {

			#print "\n$deviceHash[$j]->{'id'}: $deviceHash[$j]->{'p2pid'}\n";
			$deviceHash[$j]->{'ip'} = devices::startServer( $deviceHash[$j]->{'id'} );

		}

		for ( $j = 0 ; $j <= $#deviceHash ; $j++ ) {

			#print "\n$deviceHash[$j]->{'id'}: $deviceHash[$j]->{'p2pid'}\n";
			devices::startLogging( $deviceHash[$j] );

		}
		$ip2 = "192.168.49.1";
		for ( $j = 0 ; $j <= $#deviceHash ; $j++ ) {

			#print "\n$deviceHash[$j]->{'id'}: $deviceHash[$j]->{'p2pid'}\n";
			devices::videoStability( $deviceHash[$j], $ip2 );
			sleep 15;

		}

	}

	sleep 3000;
	exit(0);
}

elsif ( $one2many == 0 ) {
	$device1 = $ARGV[1];
	$device2 = $ARGV[2];

	devices::killProcess("checkP2P_$device1");

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

	my $temp = `adb -s $device1 shell ls /sdcard/17Again.mp4`;
	if ( $temp =~ /No such file or directory/ ) {
		system("adb -s $device1 push 17Again.mp4 /sdcard/");
	}
	else {
		print "\nVideo File already exists in device: $device1\n";
	}

	$temp = `adb -s $device2 shell ls /sdcard/17Again.mp4`;
	if ( $temp =~ /No such file or directory/ ) {
		system("adb -s $device2 push 17Again.mp4 /sdcard/");
	}
	else {
		print "\nVideo File already exists in device: $device2\n";
	}

	sleep 3;

	my $pid = fork();
	if ( not defined $pid ) {
		die 'resources not available';
	}
	elsif ( $pid == 0 ) {

#CHILD
#system("start \"wifiDirect\" /MIN cmd.exe /k sleep 5" );
#system( 1, "start \"checkP2P_$device1\" perl.exe checkP2P.pl $device1 $device2" );
		exit(0);
	}
	else {

		# PARENT -- Do nothing
		$ip1 = devices::startServer($device1);
		$ip2 = devices::startServer($device2);

		if ( $ip1 == 0 ) {
			print "\n\tUnable to establish successfull Wifi-Direct Connection..\n";
		}
		if ( $ip2 == 0 ) {
			print "\n\tUnable to establish successfull Wifi-Direct Connection..\n";
		}

		#system( 1, "perl checkP2P.pl" );

		devices::startLogging( \%deviceHash1 );
		devices::startLogging( \%deviceHash2 );

		devices::videoStability( \%deviceHash1, $ip2 );
		sleep 15;
		devices::videoStability( \%deviceHash2, $ip1 );
	}

}
