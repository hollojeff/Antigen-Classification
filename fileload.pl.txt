#!/usr/bin/perl -w

#module to load in data and add to a hash

use strict;

my %antigen;

while (my $line = <>) {
    $line =~ /(.*),\s(.*)/;
    $antigen{$1} = "$2";
}

#test (worked)

foreach my $key (keys %antigen) {
   print "$key = $antigen{$key}\n";
}
