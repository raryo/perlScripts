#!/usr/bin/perl
use strict;
use 5.10.0;

open IN, "all_prob.dat" or die "FNF\n";
while (<IN>){
    chomp;
    say nearest(3, $_);
}
close IN;

sub nearest {
    my $col = shift;
    my $val = shift;
    my $r = 10 ** $col;
    my $a = ($val > 0) ? 0.5 : -0.5;
    return int($val * $r + $a) / $r;
}
