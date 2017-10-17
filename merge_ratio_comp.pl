#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my ($comp_f, $deg_f, $idp_f) = @ARGV;

open my $idp, $idp_f or die "fnf $idp_f : $!\n";
my %is_idp;
foreach  (<$idp>){
    my ($gene, $ratio) = split;
    $is_idp{$gene}++;
}
close $idp;

open my $deg, $deg_f or die "fnf $deg_f : $!\n";
my %deg_of;
foreach  (<$deg>){
    my ($d, $comp_id) = split;
    $deg_of{$comp_id} = $d;
}
close $deg;

open my $comp, $comp_f or die "fnf $comp_f : $!\n";
while (<$comp>){
    my ($comp_id, $genes_str) = split;
    my @genes = split ";", $genes_str;
    my $all = $#genes + 1;
    my $idp_sum;
    foreach my $g (@genes){
        $idp_sum += $is_idp{$g};
    }
    my $deg = $deg_of{$comp_id} ? $deg_of{$comp_id} : 0;
    printf "%d\t%f\t%d\n", $comp_id, $idp_sum/$all, $deg;
}
close $comp;
