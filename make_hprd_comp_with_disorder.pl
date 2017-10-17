#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my ($comp_list, $disorder_list) = @ARGV;

# open disorder file.
# get disorder hash.
my %disorder;
open DIS, $disorder_list or die "can't open : $!";
while (<DIS>){
    my @fields = split;
    if (/^\*/){ $disorder{$fields[1]} = 1 } 
    else      { $disorder{$fields[0]} = 0 }
}
close DIS;

# open comp_list file.
# main loop
open IN, $comp_list or die "can't open :$!";
while (<IN>){
    my ($id, @subunits) = split;
    my @marked_subunits = map { 
        if ($disorder{$_}){ $_ .= "*" } 
        else              { $_ }
    } @subunits;
    $" = "\t";
    say "$id\t@marked_subunits";
}
close IN;
