#!/usr/bin/perl -w

use strict;

open ORGFILE, "abs.dat" or die $!;
open TTFILE, "traintest.dat" or die, $!;
 
my @original = <ORGFILE>;
my @testtrain = <TTFILE>;

my @union = my @intersection = my @difference = ();
        my %count = ();
        foreach my $element (@original, @testtrain) { $count{$element}++ }
        foreach my $element (keys %count) {
                push @union, $element;
                push @{ $count{$element} > 1 ? \@intersection : \@difference }, $element;
                }

print @difference;