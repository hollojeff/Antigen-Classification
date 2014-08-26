#!/usr/bin/perl

#Dictionary and rule classifier for Antigens
#By Jeffrey Hurst

#Takes in an array, each entry contains a code and name
#e.g. BSb58'CL, ANTI-PHOSPHORYLCHOLINE
#matches this against a regex to determine what 
#classification it should be in, then if it is in a
#certain group, eg. Virus, this takes precidence.
#returns the number of entities
#which appear in 0 or more categories.

use strict;
use DictionaryClassifer;

#load in test data
open MYDATA, "test.dat" or die $!;
my @antigen = <MYDATA>;

#pass to module to classify
my @catCount = DictionaryClassifer::Classifer(@antigen);

#show how many categories each entity is in
my %catnum;
foreach my $count (@catCount){
		$catnum{$count}++;
	}

foreach my $code (sort {$catnum{$b} <=> $catnum{$a}} keys %catnum) {
	print "$code = $catnum{$code}\n"; 
}