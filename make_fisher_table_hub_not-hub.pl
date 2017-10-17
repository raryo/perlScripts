#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my $type = shift;
my ($hub_have, $hub_dont, $not_have, $not_dont);
my $hub_file = "hub_ptm_list.dat";
my $not_file = "terminal_ptm_list.dat";

for my $kw_n (2..15){
    $hub_have  = `awk '\$$kw_n == 1' $hub_file  | wc -l`;chomp $hub_have;
    $hub_dont  = `awk '\$$kw_n == 0' $hub_file  | wc -l`;chomp $hub_dont;
    $not_have = `awk '\$$kw_n == 1' $not_file | wc -l`; chomp $not_have;
    $not_dont = `awk '\$$kw_n == 0' $not_file | wc -l`; chomp $not_dont;
    #$, = " ";
    say $hub_have, $hub_dont, $not_have, $not_dont;
}


