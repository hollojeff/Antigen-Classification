#!/usr/bin/perl

use strict;

my @category = qw/hapten lipid nucleotide peptide protein sugar virus/;

my $otp = 0;
my $ofn = 0;
my $ofp = 0;

open (CSVFILE, ">>results.csv");
print CSVFILE "catagory, TP, FP, FN, Precision, Recall, F1-score\n";
close CSVFILE;

foreach my $list (@category){
	my $tp = 0;
	my $fn = 0;
	
	open MYTEST, "$list.out" or die $!;
	my @test = <MYTEST>;
	close MYTEST;
	open MYRES, "$list.dat" or die $!;
	my @result = <MYRES>;
	close MYTEST;
	
	my $testsize = scalar(@test);
	my $ressize = scalar(@result);
	
	for (my $i=0; $i<$testsize; $i++){
		my $mark = 0;
		for (my $j=0; $j<$ressize; $j++){
			if ($test[$i] eq $result[$j]){
				$tp++;
				$test[$i] = "xxx";
				$mark = 1;
			}
		}
		if ($mark == 0){
			open (MYFILE, ">>$list.txt");
			print MYFILE "$test[$i]";
			close (MYFILE);
		}
	}
	foreach my $nomatch (@test){
		if ($nomatch ne "xxx"){
			$fn++;
		}
	}
	
	my $fp = $ressize - $tp;
	
	my $precision = $tp / ($tp + $fp);
	my $recall = $tp / ($tp + $fn);
	my $fscore = (2 * $precision * $recall) / ($precision + $recall);
	
	$otp = $otp + $tp;
	$ofp = $ofp + $fp;
	$ofn = $ofn + $fn;	
	  
	
	open (MYFILE, ">>results.txt"); 
	print MYFILE "$list\n\n";
	print MYFILE "Test file size: $testsize\n";
	print MYFILE "Result file size: $ressize\n\n";
	print MYFILE "Correct Results: $tp\\$testsize\n";
	print MYFILE "Precision = $precision\n";
	print MYFILE "Recall = $recall\n";
	print MYFILE "F1-score = $fscore\n\n";
	close MYFILE;
	
	open (CSVFILE, ">>results.csv");
	print CSVFILE "$list, $tp, $fp, $fn, $precision, $recall, $fscore\n";
	close CSVFILE;
}

my $precision = $otp / ($otp + $ofp);
my $recall = $otp / ($otp + $ofn);
my $fscore = (2 * $precision * $recall) / ($precision + $recall);
	
open (MYFILE, ">>results.txt"); 
print MYFILE "OVERALL\n\n";
print MYFILE "Precision = $precision\n";
print MYFILE "Recall = $recall\n";
print MYFILE "F1-score = $fscore\n\n";
close MYFILE;	

open (CSVFILE, ">>results.csv");
print CSVFILE "OVERALL, $otp, $ofp, $ofn, $precision, $recall, $fscore\n";
close CSVFILE;
