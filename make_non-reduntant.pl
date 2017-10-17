#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

# input from STD
my %comp_all;
while (<>){
    my ($id, @subunit) = split;
    my $sub_str = join ";", (sort @subunit);
    $comp_all{$id} = $sub_str;
}

my %cnt;
my @non_reddnt_key = grep { !$cnt{$comp_all{$_}}++ } sort keys %comp_all;

foreach  (@non_reddnt_key){
    say "$_\t$comp_all{$_}";
}
