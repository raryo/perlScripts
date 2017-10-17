#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my ($prots_list, $disorder_list) = @ARGV;

# get list of disorder proteins.
open DIS, $disorder_list or die "can't open : $!";
my %disorder;
while (<DIS>){
    chomp;
    $disorder{$_}++;
}
close DIS;

# open subunit proteins list
open IN, $prots_list or die "can't open : $!";
# main loop
while (<IN>){
    my ($gene, @swis) = split;
    foreach  (@swis){
        if ($disorder{$_}){
            $gene = "* " . $gene;
            last;
        }    
        else {
            $gene = "  " . $gene;
        } 
    }
    $gene =~ s/^ +/  /g;
    $" = "\t";
    say "$gene\t@swis";
}
close IN;
