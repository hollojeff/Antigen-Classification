#!/usr/bin/perl

#transformtest.pl by Jeffrey Hurst
#
#create the test data needed by LibSVM by transforming the data
#numerically. Each token within the training set is assigned an integer,
#this is then used to create the classes to train on. Each index number
#within a class is then assigned the percentage of how frequent it 
#appears in the data.

use strict;
use List::Util qw(sum);

open MYDATA, "train.dat" or die $!;

my @antigen = <MYDATA>;
my %list;
my @splitWord = ();

#create the dictionary - each word is assigned to an interger number
# this time doesn't need output

foreach my $wordCount (@antigen) {
	# split command to break up strings
	if ($wordCount =~ /.+?, (.+)\n/){
		@splitWord = split(/-|\s|,|\)|\(|'|\/|\.|;|=/, $1);
	}
	# put into hash - key is the word, value is the count
	foreach my $word (@splitWord){
		if ($word ne ""){
			$list{$word}++;
		}
	}
}
my $i = 1;
my %dictionary; #create dictionary hash, also create text file
foreach my $code (sort {$list{$b} <=> $list{$a}} keys %list) {
	$dictionary{$code} = $i;
	$i++;
}

open MYDATA, "test.dat" or die $!;
my @content = <MYDATA>;
	
foreach my $wordCount(@content){
	my %catdict;
	my @splitWord = ();
	if ($wordCount =~ /.+?, (.+)\n/){
		@splitWord = split(/-|\s|,|\)|\(|'|\/|\.|;|=/, $1);
	}
	foreach my $word (@splitWord){
		if ($word ne " "){
			$catdict{$dictionary{$word}}++; #if not empty, add to hash
		}
	}
	my $total = sum(values %catdict); #add together all the values for total number of tokens in entity
	my $filename = "SVMtest.dat";

	open (MYFILE, ">>$filename");
	print MYFILE "1 ";
	close (MYFILE);

	foreach my $code (sort { $a <=> $b} keys %catdict) {
		$catdict{$code} = $catdict{$code}/$total; #work out frequency of appearence
		if ($code ne ""){
			open (MYFILE, ">>$filename");
			print MYFILE "$code:$catdict{$code} ";
			close (MYFILE);
		}
	}
	open (MYFILE, ">>$filename");
	print MYFILE "\n";
	close (MYFILE);

}


	
		
			
			
			
			
			
