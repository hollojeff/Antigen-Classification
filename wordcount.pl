#!/usr/bin/perl

use Fileload
use strict

my %antigen = Fileload::Fileload;

@wordCount = values %antigen;

for (my $i=0; $i < scalar @wordCount; $i++){
  # split command to break up strings
  # put into hash - key is the word, value is the count
}

#sort by highest tally of words, then print top 20?

