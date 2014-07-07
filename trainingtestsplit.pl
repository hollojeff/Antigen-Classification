#!/usr/bin/perl -w

use strict;
 use List::Util qw(first max maxstr min minstr reduce shuffle sum);

open MYDATA, "abs.dat" or die $!;

my @input = <MYDATA>;

my @shuffle = shuffle @input;

#Split hash into a 90/10 and push out to file


my $size = int scalar @input;

my $test = int $size / 10;

for (my $i = 0; $i < $size; $i++){
	if ($i < $test){
		open (MYFILE, '>>test.dat');	
		print MYFILE "$shuffle[$i]";
		close (MYFILE);
	}
	else{
		open (MYFILE, '>>train.dat');
		print MYFILE "$shuffle[$i]";
		close (MYFILE);
	}
}