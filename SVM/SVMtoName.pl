#!/usr/bin/perl

#SVMtoName.pl by Jeffrey Hurst
#
#The results return a number which corresponds to the
#class the entity has been classified in. This list is
#in the same order as the test results. This takes the
#class number and the entity and adds it to the correct
#data file.

use strict;

open MYDATA, "test.dat" or die $!;
my @test = <MYDATA>;
open MYDATA, "SVMresult.dat" or die $!;
my @result = <MYDATA>;

for (my $i=0; $i < scalar @test; $i++){
	if ($result[$i] == 1){
		open (MYFILE, ">>hapten.dat");
		print MYFILE "$test[$i]";
		close (MYFILE);
	}
	elsif ($result[$i] == 2){
		open (MYFILE, ">>lipid.dat");
		print MYFILE "$test[$i]";
		close (MYFILE);
	}
	elsif ($result[$i] == 3){
		open (MYFILE, ">>nucleotide.dat");
		print MYFILE "$test[$i]";
		close (MYFILE);
	}
	elsif ($result[$i] == 4){
		open (MYFILE, ">>peptide.dat");
		print MYFILE "$test[$i]";
		close (MYFILE);
	}
	elsif ($result[$i] == 5){
		open (MYFILE, ">>protein.dat");
		print MYFILE "$test[$i]";
		close (MYFILE);
	}
	elsif ($result[$i] == 6){
		open (MYFILE, ">>sugar.dat");
		print MYFILE "$test[$i]";
		close (MYFILE);
	}
	elsif ($result[$i] == 7){
		open (MYFILE, ">>virus.dat");
		print MYFILE "$test[$i]";
		close (MYFILE);
	}
}
