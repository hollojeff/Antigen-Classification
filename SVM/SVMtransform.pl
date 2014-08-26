#!/usr/bin/perl

#SVMtransform.pl by Jeffrey Hurst
#
#create the training data needed by LibSVM by transforming the data
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
	open (MYFILE, '>>SVMdictionary.dat');
	print MYFILE "$i = $code\n";
	close (MYFILE);
	$dictionary{$code} = $i;
	$i++;
}

my @category = qw/hapten lipid nucleotide peptide protein sugar virus/;
my $class = 1; #order of array above determines class number, starting from 1.

foreach my $list (@category){
	open MYDATA, "$list.out" or die $!;
	my @content = <MYDATA>;
	my %catdict;
	my @splitWord = ();
	
	foreach my $wordCount(@content){
		if ($wordCount =~ /.+?, (.+)\n/){
			@splitWord = split(/-|\s|,|\)|\(|'|\/|\.|;|=/, $1);
		}
		foreach my $word (@splitWord){
			if ($word ne ""){
				$catdict{$dictionary{$word}}++; #if not empty, add to hash
			}
		}
	}
	
	my $total = sum(values %catdict); #add together all the values for total number of tokens
	my $filename = "SVMtrain.dat";
	
	open (MYFILE, ">>$filename");
	print MYFILE "$class ";
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
	$class++;
}
	
		
			
			
			
			
			
