#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my $file_n = shift;
open my $input, $file_n or die "$file_n not found. : $!\n";

while (<$input>){
    my ($gene, $len, $disop, $psipred) = split;
    my @regions = split ",", $disop;
    next unless $psipred;
    my $sum;
    foreach my $r (@regions){
        $sum -= -1 + eval $r;
    }
    say "$gene\t",$sum / $len;
}

