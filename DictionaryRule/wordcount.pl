#!/usr/bin/perl

#wordcount.pl by Jeffrey Hurst
#
# This script takes the training data, splits it into
# seperate words or tokens, then returns it as a text
# file in order from most to least common.

use strict;

open MYDATA, "train.dat" or die $!;

my @antigen = <MYDATA>;
my %list;
my @splitWord = ();

foreach my $wordCount (@antigen) {
	# split command to break up strings
	if ($wordCount =~ /.+?, (.+)\n/){
		@splitWord = split(/-|\s|,|\)|\(|'|\/|\.|;/, $1);
	}
	# put into hash - key is the word, value is the count
	foreach my $word (@splitWord){
		$list{$word}++;
	}
}

print @splitWord;

#sort by highest tally of words, then add to file.

foreach my $code (sort {$list{$b} <=> $list{$a}} keys %list) {
	open (MYFILE, '>>wordcount.txt');
	print MYFILE "$code = $list{$code}\n";
	close (MYFILE);
}
