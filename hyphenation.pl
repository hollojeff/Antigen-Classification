#

#!/usr/bin/perl

use TeX::Hyphen;
use strict;


my @antigen = ();
my %list;
my @splitWord = ();
my @hypList = ();
my $hyp = new TeX::Hyphen 'hyphen.tex';

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
			$word = lc $word;
			$word = $hyp->visualize($word);
			$word = uc $word;
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