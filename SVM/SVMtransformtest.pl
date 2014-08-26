#!/usr/bin/perl

use strict;
use List::Util qw(sum);

open MYDATA, "train.dat" or die $!;

my @antigen = <MYDATA>;
my %list;
my @splitWord = ();

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
my %dictionary;
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
			$catdict{$dictionary{$word}}++;
		}
	}
	my $total = sum(values %catdict);
	my $filename = "SVMtest.dat";

	open (MYFILE, ">>$filename");
	print MYFILE "1 ";
	close (MYFILE);

	foreach my $code (sort { $a <=> $b} keys %catdict) {
		$catdict{$code} = $catdict{$code}/$total;
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


	
		
			
			
			
			
			