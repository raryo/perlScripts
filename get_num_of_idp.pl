#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my ($comp_f, $idp_f) = @ARGV;

open my $idp, $idp_f or die "fnf $idp_f : $!\n";
my %is_idp;
foreach  (<$idp>){
    my ($gene, $ratio) = split;
    $is_idp{$gene}++;
}
close $idp;

open my $comp, $comp_f or die "fnf $comp_f : $!\n";
while (<$comp>){
    my ($comp_id, $genes_str) = split;
    my @genes = split ";", $genes_str;
    my $idp_sum;
    foreach my $g (@genes){
        $idp_sum += $is_idp{$g};
    }
    printf "%d\t%d\n", $comp_id, $idp_sum;
}
close $comp;
