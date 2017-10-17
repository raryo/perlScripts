#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my ($diso_f, $comp_f) = @ARGV;

open my $diso, $diso_f or die "fnf $diso_f : $!\n";
my (%region_of, %length_of);
while (<$diso>){
    my ($gene, $len, $regi_str, $psi) = split;
    my @regis = split ",", $regi_str;
    next unless $psi;
    $region_of{$gene} = \@regis;
    $length_of{$gene} = $len;
}


open my $comp, $comp_f or die "fnf $comp_f : $!\n";
while (<$comp>){
    my ($comp_id, $mem_str) = split;
    my @mems = split ";", $mem_str;
    my ($all, $id_len);
    foreach my $g (@mems){
        $all += $length_of{$g};
        if (!$length_of{$g}){
            say "$comp_id\tnot_on_list";
            next;
        }
        my @idr = @{$region_of{$g}};
        foreach my $r (@idr){
            $id_len -= -1 + eval $r;
        }
    }
  
    #say "$comp_id\t$all\t$id_len\t", $id_len/$all if $all;
    say "$comp_id\t", $id_len/$all if $all;
}
