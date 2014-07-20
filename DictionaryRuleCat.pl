#!/usr/bin/perl

use strict;

open MYDATA, "antigens.txt" or die $!;

my @antigen = <MYDATA>;
my @catCount = ();
my %list;
my $index = 0;

foreach my $catWord (@antigen) {
	# split command to break up strings and set up counters
	my @splitWord = split(/-|\s|,|\)|\(|'|\/|\.|;/, $catWord);
	my $procount=0; my $saccount=0; my $pepcount=0; my $nuccount=0; 
	my $lipcount=0; my $hapcount=0; my $vircount=0;
	foreach my $word (@splitWord){
		# Look at each word in turn to see if it matches or contains a suffix
		# check for virus
		if ($word =~ /VIRUS|VIRUS\n|HIV|INFLUENZA[E?]|CAPSULAR|ARS/){
			$vircount = 1;	
		}
		# check for protein
		elsif ($word =~ /PROTEIN\z|COLLAGEN|HISTONE|CYTOCROME|ALLERGEN|INTERFERON|CYTOCHROME|IN\z|ASE\z|YME\z|IDE\z|IGG[\w?\w?]|IGG|CD[\d\S]|RH|SM|FACTOR|ANTIBODY|ANTIBODY\n/){
			$procount = 1;
		}
		# check for saccharide
		elsif ($word =~ /SACCHARIDE\z|POLYSACCHARIDE|CARBOHYDRATE|GLUCURONOXYLOMANNAN|DEXTRAN|OSE\z|SAN\z/){
			$saccount = 1;
		}
		# check for peptide
		elsif ($word =~ /PEPTIDE|TRYPTOPHAN|CYCLOSPORINE|\bALA\b|\bARG\b|\bASN\b|\bASP\b|\bASX\b|\bCYS\b|\bGLU\b|\bGLN\b|\bGLX\b|\bGLY\b|\bHIS\b|\bILE\b|\bLEU\b|\bLYS\b|\bMET\b|\bPHE\b|\bPRO\b|\bSER\b|\bTHR\b|\bTRP\b|\bTYR\b|\bVAL\b|\bALA[\d*]|\bARG[\d*]|\bASN[\d*]|\bASP[\d*]|\bASX[\d*]|\bCYS[\d*]|\bGLU[\d*]|\bGLN[\d*]|\bGLX[\d*]|\bGLY[\d*]|\bHIS[\d*]|\bILE[\d*]|\bLEU[\d*]|\bLYS[\d*]|\bMET[\d*]|\bPHE[\d*]|\bPRO[\d*]|\bSER[\d*]|\bTHR[\d*]|\bTRP[\d*]|\bTYR[\d*]|\bVAL[\d*]/){
			$pepcount = 1;
		}
		# check for nucleic acid
		elsif ($word =~ /RNA\z|DNA\z/){
			$nuccount = 1;
		}
		# check for lipid
		elsif ($word =~ /LIPID\n|FATTY|CHOLINE\z|OIC\z/){
			$lipcount = 1;
		}
		# check for hapten
		elsif ($word =~ /YL\z|ONE\z|AMINE\z|DNP|AZOPHENYLARSONATE|MORPHINE/){
			$hapcount = 1;
		}
		
	}
	
	#check whole string for hapten, e.g. 1,6 where this would normally be split up
	if ($catWord =~ /\d,\d/){
			$hapcount = 1;
		}
		
	if ($vircount == 1){
	$procount = $saccount = $lipcount = $hapcount = $nuccount = $pepcount = 0;
	open (MYFILE, '>>virus.dat');
	print MYFILE "$index, $catWord";
	close (MYFILE);	
	}
	if ($procount == 1){
		$saccount = $lipcount = $hapcount = $nuccount = $pepcount = 0;
		open (MYFILE, '>>protein.dat');
		print MYFILE "$index, $catWord";
		close (MYFILE);
	}
	if ($saccount == 1){
		open (MYFILE, '>>saccharide.dat');
		print MYFILE "$index, $catWord";
		close (MYFILE);
	}
	if ($lipcount == 1){
		open (MYFILE, '>>lipid.dat');
		print MYFILE "$index, $catWord";
		close (MYFILE);
	}
	if ($hapcount == 1){
		open (MYFILE, '>>hapten.dat');
		print MYFILE "$index, $catWord";
		close (MYFILE);
	}	
	if ($nuccount == 1){
		open (MYFILE, '>>nucleic.dat');
		print MYFILE "$index, $catWord";
		close (MYFILE);
	}
	if ($pepcount == 1){
		open (MYFILE, '>>peptide.dat');
		print MYFILE "$index, $catWord";
		close (MYFILE);
	}
	if ($vircount == 0 && $pepcount == 0 && $procount == 0 && $nuccount == 0 && $hapcount == 0 && $saccount == 0 && $lipcount == 0){
		open (MYFILE, '>>unknown.dat');
		print MYFILE "$index, $catWord";
		close (MYFILE);
	}
	$catCount[$index] = $procount + $saccount + $pepcount + $nuccount + $lipcount + $hapcount + $vircount;
	$index++;
}

my %catnum;

foreach my $count (@catCount){
		$catnum{$count}++;
	}

foreach my $code (sort {$catnum{$b} <=> $catnum{$a}} keys %catnum) {
	print "$code = $catnum{$code}\n"; 
}