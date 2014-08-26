#!/usr/bin/perl

use strict;

open MYDATA, "protein.out" or die $!;

my @antigen = sort <MYDATA>;

print "Name of output file:\n";
my $input = <STDIN>;
chomp $input;

foreach my $code(@antigen){
	open (MYFILE, ">>$input");
	print MYFILE "$antigen[$code]";
	close (MYFILE);
}