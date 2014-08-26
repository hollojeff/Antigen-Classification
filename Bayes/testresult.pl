#!/usr/bin/perl

# testresult.pl by Jeffrey Hurst
#
# This script takes the output from the classifiers and
# tests it against a pre-classified set of data. This
# then works out the precision, recall and F-score
# and returns it as a text file, in a csv file and
# any unmatched entities.

use strict;

my @category = qw/hapten lipid nucleotide peptide protein sugar virus/;

#set the overall true positive, false positive and false negative outside the loop
my $otp = 0;
my $ofn = 0;
my $ofp = 0;

#create csv file and add column headers
open (CSVFILE, ">>results.csv");
print CSVFILE "category, TP, FP, FN, Precision, Recall, F1-score\n";
close CSVFILE;

foreach my $list (@category){
	my $tp = 0;
	my $fn = 0;
	
	open MYTEST, "$list.out" or die $!; #load pre-classified data
	my @test = <MYTEST>;
	close MYTEST;
	open MYRES, "$list.dat" or die $!; #load results
	my @result = <MYRES>;
	close MYTEST;
	
	my $testsize = scalar(@test);
	my $ressize = scalar(@result);
	
	#test the results against the classifed data. If there is a
	#match remove the entity.
	for (my $i=0; $i<$testsize; $i++){
		my $mark = 0;
		for (my $j=0; $j<$ressize; $j++){
			if ($test[$i] eq $result[$j]){
				$tp++; #match made; add to true positive
				$test[$i] = "xxx"; #make sure entity is not matched again
				$mark = 1;
			}
		}
		# if no match add to text file
		if ($mark == 0){
			open (MYFILE, ">>$list.txt");
			print MYFILE "$test[$i]";
			close (MYFILE);
		}
	}
	# count any that do not match as false negatives
	foreach my $nomatch (@test){
		if ($nomatch ne "xxx"){
			$fn++;
		}
	}
	
	my $fp = $ressize - $tp; #any unmatched results are counted as false positives
	
	#work our precision, recall and fscore
	my $precision = $tp / ($tp + $fp);
	my $recall = $tp / ($tp + $fn);
	my $fscore = (2 * $precision * $recall) / ($precision + $recall);
	
	#add to overall tp, fp and fn.
	$otp = $otp + $tp;
	$ofp = $ofp + $fp;
	$ofn = $ofn + $fn;	
	  
	#create results file
	open (MYFILE, ">>results.txt"); 
	print MYFILE "$list\n\n";
	print MYFILE "Test file size: $testsize\n";
	print MYFILE "Result file size: $ressize\n\n";
	print MYFILE "Correct Results: $tp\\$testsize\n";
	print MYFILE "Precision = $precision\n";
	print MYFILE "Recall = $recall\n";
	print MYFILE "F1-score = $fscore\n\n";
	close MYFILE;
	
	#add to csv file
	open (CSVFILE, ">>results.csv");
	print CSVFILE "$list, $tp, $fp, $fn, $precision, $recall, $fscore\n";
	close CSVFILE;
}

#work out results for all categories together 
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
