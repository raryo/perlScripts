#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my ($comp_id_list, $subunit_list) = @ARGV;

open my $sub, $subunit_list or die "file not found : $!\n";
my %subunit_of;
while (<$sub>){
    my ($comp_id, $sw_str, $gene_str) = split;
    my @sw_subunits = split ";", $sw_str;
    my @gene_subunits = split ";", $gene_str;
    my @all_str;
    foreach my $i (0 .. $#sw_subunits){
        my $tmp_str = $sw_subunits[$i] . " " . $gene_subunits[$i];
        push @all_str, $tmp_str;
    }
    my $all_sub = join "\n", @all_str;
    $subunit_of{$comp_id} = $all_sub;
}
close $sub;

open my $comps , $comp_id_list or die "file not found : $!\n";
while (<$comps>){
    my ($comp_id, @dumps) = split;
    say "$subunit_of{$comp_id}";
}
close $comps;
