use devices;
devices::detect();
devices::display();
$| = 1;

our @deviceList;

Target:
do {
	print "\nPlease choose the Target to be profiled: 

*********************************
*	1. One to One Scenario 	*
*	2. One to Many Scenario	*
*	0. To Exit              *
*********************************

Enter option: ";
	$Choice = <>;
	chomp($Choice);
} while ( !( $Choice == 1 || $Choice == 2 || $Choice == 0 ) );

if ( $Choice == 0 ) {
	print "\nhope to see you back soon :) ";
	sleep 20;
	exit(0);
}
else {
  Target:
	$i = 1;

	do {
		print "\nPlease enter device$i id (0 to Stop):";
		$deviceList[ $i - 1 ] = <>;
		chomp( $deviceList[ $i - 1 ] );
		$i++;
	} while ( !( $deviceList[ $i - 2 ] eq '0' ) );

	if ( ( $Choice == 1 ) && ( ( $#deviceList % 2 ) != 0 ) ) {
		print "\n\nPlease enter Even Number of Devices for one2one Scenario\n\n";
		goto Target;
	}

	print "\nFollowing device IDs will be under test: \n";
	for ( $j = 0 ; $j < $#deviceList ; $j++ ) {
		print "\tDevice " . ( $j + 1 ) . ":" . $deviceList[$j] . "\n";
	}

	system("mkdir Logs");

	my $pid = fork();
	if ( not defined $pid ) {
		die 'resources not available';
	}
	elsif ( $pid == 0 ) {

		#CHILD
		system( 1, "start \"CrashLogs_$deviceList[0]\" perl.exe crashLog.pl" );
		if ( $Choice == 2 ) {
			print("start \"P2P_Video_Stability_$deviceList[0]\" perl.exe P2P_Video_Stability.pl 1 @deviceList | tee Logs/stdout.log");
			system( 1, "start \"P2P_Video_Stability_$deviceList[0]\" perl.exe P2P_Video_Stability.pl 1 @deviceList | tee Logs/stdout.log" );
		}
		elsif ( $Choice == 1 ) {
			print("start \"P2P_Video_Stability_$deviceList[0]\" perl.exe P2P_Video_Stability.pl 0 @deviceList | tee Logs/stdout.log");
			system( 1, "start \"P2P_Video_Stability_$deviceList[0]\" perl.exe P2P_Video_Stability.pl 0 @deviceList | tee Logs/stdout.log" );
		}

	}
}
