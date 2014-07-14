use devices;
$| = 1;
my $one2many = $ARGV[0];

if ( $one2many == 1 ) {
	for ( my $j = 0 ; $j < $#ARGV ; $j++ ) {
		if ( !( $j == 0 || $j == $#ARGV ) )    #Ignore first and last argument
		{
			$deviceList[ $j - 1 ] = $ARGV[$j];
		}
	}
}

for ( my $j = 0 ; $j <= $#deviceList ; $j++ ) {
	push( @deviceHash, { %{ devices::genHash( $deviceList[$j] ) } } );
}
while (1)
{
	for ( my $j = 0 ; $j <= $#deviceList ; $j++ ) {
		checkDisconnect( $deviceHash[$j]->{'id'} );
		sleep(5);
	}
}

sub checkDisconnect
{
	$device = $_[0];
	print "\nadb -s $device shell ping -c 1 192.168.49.1\n";
	@out = `adb -s $device shell ping -c 1 192.168.49.1`;

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
	else {

		if ( $disconnect == 1 )
		{
			devices::killProcess("P2P_Video_Stability_$deviceHash[0]->{'id'}");

			for ( my $j = 0 ; $j <= $#deviceList ; $j++ ) {
				killRun( $deviceHash[$j] );
				sleep 5;
			}
			print "\n\nRe-initiating the tests..\n\n";

			my $pid = fork();
			if ( not defined $pid ) {
				die 'resources not available';
			} elsif ( $pid == 0 ) {

				#CHILD
				#system("start \"wifiDirect\" /MIN cmd.exe /k sleep 5" );
				print("\nstart \"P2P_Video_Stability_$deviceList[0]\" perl.exe P2P_Video_Stability.pl 1 @deviceList 0 | tee Logs/stdout.log\n");
				system( 1, "start \"P2P_Video_Stability_$deviceList[0]\" perl.exe P2P_Video_Stability.pl 1 @deviceList 0 | tee Logs/stdout.log" );

			} else {

				# PARENT -- Do nothing
			}

			sleep 20;
			exit(0);
		}
	}
}

sub killRun {
	my $deviceRef = $_[0];
	my %device    = %{$deviceRef};
	print("\n\nKilling all processes of $device{'id'}... \n\n");
	devices::killProcess( $device{'adb'} );
	devices::killProcess( $device{'kernel'} );
	devices::killProcess( $device{'video'} );

	system("adb -s $device{'id'} shell input keyevent 3");

}
