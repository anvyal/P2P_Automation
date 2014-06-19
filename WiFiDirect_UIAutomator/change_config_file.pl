open FILE, "p2p_supplicant_connected.conf" or die $!;
open TEMP, ">p2p_supplicant.conf" or die $!;
@out = <FILE>;
our @file,$i;

foreach (@out) {
if($_ =~ "network={")
{
print"Hellow";
last;
}
$file[i]=$_;
print TEMP $file[i];
$i++;
}

foreach (@file) {
print $_;
}