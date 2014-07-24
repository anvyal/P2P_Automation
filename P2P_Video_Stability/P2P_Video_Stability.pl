#use strict;
require devices;
$debug = 1;

$| = 1;
our $one2many = $ARGV[0];
chomp($one2many);

our @deviceList;
our @deviceHash;

$Time = devices::getTime();

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

if ( $one2many == 0 ) {

	$exitLoop = $#deviceHash;
}
else {
	$exitLoop = 1;
}

#In one2many, p2pSetup for first 2 devices
for ( $j = 0 ; $j <= $exitLoop ; $j++ ) {
	print "\nTest:\n";

	#while ( ( $key, $value ) = each( %{ $deviceHash[$j] } ) ) {
	#	print $key. ", " . $value . "\n";
	#}

	devices::openWifiDirect( $deviceHash[$j]->{'id'} );

	#Adds an item to deviceHash
	$deviceHash[$j]->{'p2pid'} = `adb -s $deviceHash[$j]->{'id'} shell getprop P2PdeviceID`;

	if ( $j != 0 ) {

		#devices::searchDevices( $deviceHash[ $j - 1 ]->{'id'} );
		#sleep(2);
		if ( $one2many == 0 ) {
			if ( ( $j % 2 ) == 0 ) {
				next;
			}
		}
		devices::sendInvite( $deviceHash[$j]->{'id'}, $deviceHash[ $j - 1 ]->{'p2pid'} );
		sleep(2);
		devices::acceptInvite( $deviceHash[ $j - 1 ]->{'id'} );
	}
}

print "\nPress any Key\n";
sleep 20;

#isConnected
for ( $j = 0 ; $j <= $exitLoop ; $j++ ) {

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

if ( $one2many == 1 ) {

	#identify GO
	$goID = devices::getGoID( \@deviceHash );

	#identify client
	for ( $j = 0 ; $j <= 1 ; $j++ ) {
		if ( $deviceHash[$j]->{'id'} eq $goID ) {
			print "\n\nIn Identify client if\(\$goID\):\n\$deviceHash[$j]->{'id'}=$deviceHash[$j]->{'id'}, \$goID = $goID\n" if ( $debug == 1 );
		}
		else {
			$clientID = $deviceHash[$j]->{'id'};
			print "\n\n\$clientID = $clientID\n" if ( $debug == 1 );
		}
	}

	#get client PSK
	$clientRef = devices::getPSK($clientID);
	$clientRef->{goID} = $goID;
	print "\ngoID: $clientRef->{goID}\n";
	for ( $j = 2 ; $j <= $#deviceHash ; $j++ ) {
		$clientRef->{id} = $deviceHash[$j]->{'id'};
		devices::connectP2PWiFi($clientRef);
	}

	sleep 3;
}
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

	#Start Server
	#In one2many scenario, only server runs in GO
	if ( $one2many == 1 ) {
		for ( $j = 0 ; $j <= $#deviceHash ; $j++ ) {
			if ( $deviceHash[$j]->{'id'} eq $goID ) {
				$deviceHash[$j]->{'ip'} = devices::startServer( $deviceHash[$j]->{'id'} );
			}
		}
	}
	else {
		for ( $j = 0 ; $j <= $#deviceHash ; $j++ ) {

			#print "\n$deviceHash[$j]->{'id'}: $deviceHash[$j]->{'p2pid'}\n";
			$deviceHash[$j]->{'ip'} = devices::startServer( $deviceHash[$j]->{'id'} );

		}
	}

	for ( $j = 0 ; $j <= $#deviceHash ; $j++ ) {

		#print "\n$deviceHash[$j]->{'id'}: $deviceHash[$j]->{'p2pid'}\n";
		devices::startLogging( $deviceHash[$j], $Time );

	}
	$ip2 = "192.168.49.1";
	for ( $j = 0 ; $j <= $#deviceHash ; $j++ ) {

		if ( $one2many == 1 ) {

			#print "\n$deviceHash[$j]->{'id'}: $deviceHash[$j]->{'p2pid'}\n";
			devices::videoStability( $deviceHash[$j], $ip2 );
			sleep 20;
		}
		else {
			if ( ( $j % 2 ) != 0 ) {
				devices::videoStability( $deviceHash[$j], $deviceHash[ ( $j - 1 ) ]->{'ip'} );
				sleep 20;
			}
			else {
				devices::videoStability( $deviceHash[$j], $deviceHash[ ( $j + 1 ) ]->{'ip'} );
				sleep 20;
			}
		}

	}

}
