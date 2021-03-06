#!/usr/bin/perl

#Dictionary and rule classifier for Antigens
#By Jeffrey Hurst

#Takes in an array, each entry contains a code and name
#e.g. BSb58'CL, ANTI-PHOSPHORYLCHOLINE
#matches this against a regex to determine what 
#classification it should be in, then if it is in a
#certain group, eg. Virus, this takes precidence.
#returns an array which contains the number of entities
#which appear in 0 or more categories.

#Input: Array
#Output: Array

package DictionaryClassifier;

sub Classify(){

	foreach my $catWord (@antigen) {
		# split command to break up strings
		my @splitWord =();
		if ($catWord =~ /.+?, (.+)\n/){
			@splitWord = split(/-|\s|,|\)|\(|'|\/|\.|;/, $1);
		}
		# set up counters for classification
		my $procount=0; my $saccount=0; my $pepcount=0; my $nuccount=0; 
		my $lipcount=0; my $hapcount=0; my $vircount=0;
		foreach my $word (@splitWord){
			$word =~ s/\.//;
			chomp $word;
			# Look at each word in turn to see if it matches or contains a suffix
			# check for virus
			if ($word =~ /VIRUS|VIRUS\n|HIV|INFLUENZA[E?]|CAPSULAR/){
				$vircount = 1;	
			}
			# check for protein
			elsif ($word =~ /PROTEIN\z|HLA|COLLAGEN|MELANOMA|LEUKEMIA|TOX|NUCLEOLAR|LYMPHOCYTIC|HISTONE|OME\z|ALLERGEN|IDIOTYPIC|POLYREACTIVE|MONOREACTIVE|LAMBDA|KAPPA|INTERFERON|POLYCATION|ERYTHROCYTE|FRACTION|FECAL|IN\z|INS\z|ASE\z|YME\z|[^PEPT]IDE\z|IG[\w?\w?]|IGg|CD[\d\S]|P[\d+?]E?|H[\d]|RH|SM|FACTOR|ANTIBOD|ANTIBODY\n|ANTIGEN|ACHR|3M|ARS\z/){
				$procount = 1;
			}
			# check for saccharide
			elsif ($word =~ /SACCHARIDE\z|GAL|CARBOHYDRATE|GLUCURONOXYLOMANNAN|DEXTRAN|LEVAN|OSE\z|SAN\z|MCPS/){
				$saccount = 1;
			}
			# check for peptide
			elsif ($word =~ /PEPTIDE|TRYPTOPHAN|CYCLOSPORINE|PS[1+I+]CT3|^ALA$|^ARG$|^ASN$|^ASP$|^ASX$|^CYS$|^GLU$|^GLN$|^GLX$|^GLY$|^HIS$|^ILE$|^LEU$|^LYS$|^MET$|^PHE$|^PRO$|^SER$|^THR$|^TRP$|^TYR$|^VAL$|^ALA[\d*]|^ARG[\d*]|^ASN[\d*]|^ASP[\d*]|^ASX[\d*]|^CYS[\d*]|^GLU[\d*]|^GLN[\d*]|^GLX[\d*]|^GLY[\d*]|^HIS[\d*]|^ILE[\d*]|^LEU[\d*]|^LYS[\d*]|^MET[\d*]|^PHE[\d*]|^PRO[\d*]|^SER[\d*]|^THR[\d*]|^TRP[\d*]|^TYR[\d*]|^VAL[\d*]/){
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
			elsif ($word =~ /{YL\z|ONE\z|OL\z|ENE\z|AMINE\z|DNP|AZOPHENYLARSONATE|CORTISOL|QUANOSINE|MORPHINE|ACETYL|PHENYL\z/){
				$hapcount = 1;
			}
			
		}
		#if the counter returns true, add to file.
		if ($vircount == 1){
		$procount = $saccount = $lipcount = $hapcount = $nuccount = $pepcount = 0;
		open (MYFILE, '>>virus.dat');
		print MYFILE "$catWord";
		close (MYFILE);	
		}
		if ($procount == 1){
			$saccount = $lipcount = $hapcount = $nuccount = $pepcount = 0;
			open (MYFILE, '>>protein.dat');
			print MYFILE "$catWord";
			close (MYFILE);
		}
		if ($pepcount == 1){
			$saccount = $lipcount = $hapcount = $nuccount = 0;
			open (MYFILE, '>>peptide.dat');
			print MYFILE "$catWord";
			close (MYFILE);
		}
		if ($saccount == 1){
			$lipcount = $hapcount = $nuccount = 0;
			open (MYFILE, '>>sugar.dat');
			print MYFILE "$catWord";
			close (MYFILE);
		}
		if ($lipcount == 1){
			$hapcount = 0;
			open (MYFILE, '>>lipid.dat');
			print MYFILE "$catWord";
			close (MYFILE);
		}
		if ($hapcount == 1){
			open (MYFILE, '>>hapten.dat');
			print MYFILE "$catWord";
			close (MYFILE);
		}	
		if ($nuccount == 1){
			open (MYFILE, '>>nucleotide.dat');
			print MYFILE "$catWord";
			close (MYFILE);
		}
		#if it does not match any regex, entity goes here
		if ($vircount == 0 && $pepcount == 0 && $procount == 0 && $nuccount == 0 && $hapcount == 0 && $saccount == 0 && $lipcount == 0){
			open (MYFILE, '>>other.dat');
			print MYFILE "$catWord";
			close (MYFILE);
		}
		#if it matches more than 1 regex, it is also put here to flag.
		if ($vircount + $pepcount + $procount + $nuccount + $hapcount + $saccount +	$lipcount > 1){
			open (MYFILE, '>>multiple.dat');
			print MYFILE "$catWord";
			close (MYFILE);
		}
		#take count 
		$catCount[$index] = $procount + $saccount + $pepcount + $nuccount + $lipcount + $hapcount + $vircount;
		$index++;
	}
}
return @catCount;
1;