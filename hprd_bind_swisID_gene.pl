#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

#open IN, "head hprd_all_subunit_proteins.dat|" or die "can't open :$!";
open IN, "hprd_all_subunit_proteins.dat" or die "can't open :$!";

while (my $gene_id = <IN>){
    chomp $gene_id;
    my @grep_result = `grep -w $gene_id hprd_id_mappings_cut.dat`;
    foreach  (@grep_result){
        s/,/\t/g;
        my ($hprd_geneID, @swisID) = split;
        $" = "\t";
        say "$hprd_geneID\t@swisID";
    }
}
