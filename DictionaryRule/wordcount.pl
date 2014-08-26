#!/usr/bin/perl

use strict;

open MYDATA, "unknown.dat" or die $!;

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

#sort by highest tally of words, then print top 20?

foreach my $code (sort {$list{$b} <=> $list{$a}} keys %list) {
	open (MYFILE, '>>unknownwordcount.dat');
	print MYFILE "$code = $list{$code}\n";
	close (MYFILE);
}