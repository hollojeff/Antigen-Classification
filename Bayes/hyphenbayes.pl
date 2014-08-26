#!/usr/bin/perl

use strict;
use Algorithm::NaiveBayes;

my $nb = Algorithm::NaiveBayes->new;

my @category = qw/hapten lipid nucleotide other peptide protein sugar virus/;

#load in lists of syllables by category from the training set.
foreach my $list (@category){
	open MYDATA, "$list.dat" or die $!;
	my @content = <MYDATA>;
	my %attributes;
	foreach my $word (@content){
		if ($word =~ /(.+?) = (.+?)\n/){ #split into syllable and count, add to hash.
			$attributes{$1} = $2;
		}
	}
	
	$nb->add_instance(attributes => {%attributes}, label => "$list");
}

$nb->train;

#load in test data (make sure it's syllablized first.)
open MYDATA, "testhyp.dat" or die $!;
my @content = <MYDATA>;
open MYTEST, "test.dat" or die $!;
my @unhyp = <MYTEST>;

my @splitWord = ();

for (my $i = 0; $i < scalar @content; $i++){
	my %attributes;
	# split command to break up strings
	if ($content[$i] =~ /.+?, (.+)\n/){
		@splitWord = split(/-|\s/, $1);
	}
	# put into hash - key is the word, value is the count
	foreach my $word (@splitWord){
		$attributes{$word}++;
	}
	my %result = %{$nb->predict (attributes => {%attributes})};
	my $key = (sort { $result {$b} <=> $result {$a} } keys %result)[0];
	
	open (MYFILE, ">>result/$key.dat");
	print MYFILE "$unhyp[$i]";
	close (MYFILE);
}
	
	

