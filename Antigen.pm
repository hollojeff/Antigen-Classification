package Antigen;

#module to load in data and add to a hash
use strict;

sub Fileload{

    my %antigen;

    while (my $line = <>) {
        $line =~ /(.*),\s(.*)/;
        $antigen{$1} = "$2";
    }
    return %antigen;
}
1;
