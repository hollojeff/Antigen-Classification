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
open MYDATA,