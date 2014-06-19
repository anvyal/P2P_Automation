#!/usr/bin/perl -w

### More on Regular Expressions ###
### Pattern Matching  ###

sub print_array    # Print the full contents of the Array
{
	for ( $i = 0 ; $i <= $#strings ; $i++ ) {
		print $strings[$i], "\n";
	}
	print "\n\n";
}

sub grep_pattern    # Print strings which contain the pattern
{
	foreach (@strings) {
		print "$_\n" if /$pattern/;
	}
	print "\n\n";
}

### Setting up the Array of strings

@strings = ( "Two, 4, 6, Eight", "Perl is cryptic", "Perl is great" );

@strings[ 3 .. 6 ] =
  ( "1, Three", "Five, 7", "Write in Perl", "Programmer's heaven" );
print_array;

## Find the word "Perl"
$pattern = 'Perl';
print "Searching for: $pattern\n";
grep_pattern;

## Find "Perl" at the beginning of a line
$pattern = '^Perl';
print "Searching for: $pattern\n";
grep_pattern;

## Find sentences that contain an "i"
$pattern = 'i';
print "Searching for: $pattern\n";
grep_pattern;

## Find words starting in "i", i.e. a space preceeds the letter
$pattern = '\si';
print "Searching for: $pattern\n";
grep_pattern;

## Find strings containing a digit
$pattern = '\d';
print "Searching for: $pattern\n";
grep_pattern;

## Search for a digit followed by some stuff
$pattern = '\d+.+';
print "Searching for: $pattern\n";
grep_pattern;

## Find strings with a digit at the end of a line
$pattern = '\d+$';
print "Searching for: $pattern\n";
grep_pattern;

## Search for a digit, possible stuff in between, and another digit
$pattern = '\d.*\d';
print "Searching for: $pattern\n";
grep_pattern;

## Find four-letter words, i.e. four characters offset by word boundaries
$pattern = '\b\w{4}\b';
print "Searching for: $pattern\n";
grep_pattern;

## Sentences with three words, three word fields separated by white space
$pattern = '\w+\s+\w+\s+\w+';
print "Searching for: $pattern\n";
grep_pattern;

## Find sentences with two "e" letters, and possible stuff between
$pattern = 'e.*e';
print "Searching for: $pattern\n";
grep_pattern;

#### Marking Regular Expression Sub-strings and Using Substitution

## Substitute "Pascal" for "Perl" words at the beginning of a line
print "Substituting first Perl words.\n";
foreach (@strings) {
	s/^Perl/Pascal/g;
}
print_array;

## Find five-letter words and replace with "Amazing"
$pattern = '\b\w{5}\b';
print "Searching for: $pattern\n";
foreach (@strings) {
	s/$pattern/Amazing/;
}
print_array;

## Replace any "Perl" words at the end of a line with "Cobol"
print "Substituting Final Perl \n";
foreach (@strings) {
	s/Perl$/Cobol/;
}
print_array;

## Delete any apostrophes followed by an "s"
print "Substituting null strings\n";
foreach (@strings) {
	s/\'s//;    # Replace with null string
}
print_array;

## Search for two digits in same line, and switch their positions
print "Tagging Parts and Switching Places\n";
foreach (@strings) {
	$pattern = '(\d)(.*)(\d)';
	if (/$pattern/) {
		print "Grabbed pattern: $pattern   \$1 = $1   \$2 = $2   \$3 = $3\n";
		s/$pattern/$3$2$1/;
	}
}
print "\n";
print_array;

## Marking Patterns and using multiple times
print "Expanding Patterns, and apply more than once in the same line\n";
foreach (@strings) {
	$pattern = '(\d)';
	if (/$pattern/) {
		s/$pattern/$1$1$1/g;
	}
}
print "\n";
print_array;

## Marking things between word boundaries.  Using part of pattern
print "Replacing words that end with n \n";
foreach (@strings) {
	$pattern = '\b(\w*)n\b';
	if (/$pattern/) {
		print "Grabbed pattern: $pattern   \$1 = $1   \n";
		s/$pattern/$1s/;
	}
}
print "\n";
print_array;

## Sentences with three words, add "n't" after the middle word
$pattern = '(\w+\s+)(\w+)(\s+\w+)';
print "Searching for: $pattern\n";
foreach (@strings) {
	s/$pattern/$1$2n\'t$3/;
}
print_array;

## Words with either an "o" or an "e" in them
$pattern = '[oe]';
print "Searching for: $pattern\n";
foreach (@strings) {
	s/$pattern/x/g;
}
print_array;

