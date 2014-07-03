#!/usr/bin/perl -w

use strict;

my %antigen;

while (my $line = <>) {
    $line =~ /(.+?),(.+)/;
    $antigen{$1} = "$2";
}

#Split hash into a 90/10 and push out to file

my @names = keys %antigen;
my $size = int @names / 10;
	
for (my $i=0; $i<$size; $i++){
	
	open (MYFILE, '>>test.dat');	
	print MYFILE "$names[$i],$antigen{$names[$i]}\n";
	close (MYFILE);
	delete $antigen{$names[$i]};
	}

foreach my $key (keys %antigen) {
	open (MYFILE, '>>train.dat');
	print MYFILE "$key,$antigen{$key}\n";
	close (MYFILE);
}