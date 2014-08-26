#!/usr/bin/perl

use strict;

my @antigen = ();
my %list;
my @splitWord = ();

while (my $line = <>){
	push (@antigen, $line);
}

foreach my $wordCount (@antigen) {
	# split command to break up strings
	if ($wordCount =~ /.+?, (.+)\n/){
		@splitWord = split(/-|\s/, $1);
	}
	# put into hash - key is the word, value is the count
	foreach my $word (@splitWord){
		$list{$word}++;
	}
}

print "Name of output file:\n";
my $input = <STDIN>;
chomp $input;

foreach my $code (sort {$list{$b} <=> $list{$a}} keys %list) {
	open (MYFILE, ">>$input");
	print MYFILE "$code = $list{$code}\n";
	close (MYFILE);
	}