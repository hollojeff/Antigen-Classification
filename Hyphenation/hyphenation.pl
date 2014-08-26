#!/usr/bin/perl

#hyphenation.pl by Jeffrey Hurst
#
# Using the TeX::Hyphen module by Jan Pazdziora to split
# entities into syllables with the antigenhyph.tex file.
# Asks for filename to be outputted, which then creates
# a text file.

use TeX::Hyphen;
use strict;


my @antigen = ();
my %list;
my @splitWord = ();
my @hypList = ();
my $hyp = new TeX::Hyphen 'antigenhyph.tex'; #load in hyphen rules

while (my $line = <>){
	push (@antigen, $line);
}
		
foreach my $wordCount (@antigen) {

	# split command to break up strings
	if ($wordCount =~ /(.+?,) (.+)\n/){
		@splitWord = split(/-|\s|,|\)|\(|'|\//, $2);
		my @hypWord = ();
		# put into hash - key is the word, value is the count
		foreach my $word (@splitWord){
			$word = lc $word; #hyphen file is lower case
			$word = $hyp->visualize($word); #splits word
			$word = uc $word; #antigen names are upper case
			push (@hypWord,  $word)
		}
		unshift @hypWord, $1; 
		push (@hypList, join(' ', @hypWord));
	}
}

print "Name of output file:\n";
my $input = <STDIN>;
chomp $input;

foreach my $code (@hypList){ 
		open (MYFILE, ">>$input");
		print MYFILE "$code\n";
		close (MYFILE);
}
