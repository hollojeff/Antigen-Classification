#!/usr/bin/perl

use Antigen;
use strict;

my %antigen = Antigen::Fileload;

my @wordCount = values %antigen;
print scalar @wordCount,"\n";
my %list;

for (my $i=0; $i < scalar @wordCount; $i++){
	# split command to break up strings
	my @splitWord = split(/-|\s/, $wordCount[$i]);

	# put into hash - key is the word, value is the count
	foreach my $word (@splitWord){
		$list{$word}++;
	}
}

#sort by highest tally of words, then print top 20?

foreach my $code (sort {$list{$a} <=> $list{$b}} keys %list) {
   print "$code = $list{$code}\n"; 
}