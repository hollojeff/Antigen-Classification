#!/usr/bin/perl

use strict;

open MYDATA, "train.dat" or die $!;

my @antigen = <MYDATA>;
my %list;
my @splitWord = ();

foreach my $wordCount (@antigen) {
	# split command to break up strings
	@splitWord = split(/-|\s|,|\)|\(|'|\//, $wordCount);

	# put into hash - key is the word, value is the count
	foreach my $word (@splitWord){
		$list{$word}++;
	}
}

print @splitWord;

#sort by highest tally of words, then print top 20?

foreach my $code (sort {$list{$b} <=> $list{$a}} keys %list) {
	if (length($code) > 2){
	open (MYFILE, '>>wordcount.dat');
	print MYFILE "$code = $list{$code}\n";
	close (MYFILE);
	}
}