#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

############################################
# input  : HPRD/PROTEIN_COMPLEX.dat as STD #
# output : hprd_comp_list.dat              #
############################################

my %complex;
while (<>){
    my ($id, $d, $gene, @dump) = split;
    push @{$complex{$id}}, $gene;
}

# make non-redundant
my %cnt;
my @uniq_keys = grep {
    my $subunit_str = join ";", sort @{$complex{$_}};
    $subunit_str !~ /-;/ and !$cnt{$subunit_str}++;
} sort keys %complex;

# output 
say "hprd__ID\tsubunits";
foreach my $i (sort @uniq_keys){
    my @sub = sort @{$complex{$i}};
    $" = ";";
    print "$i\t@sub\n";
}
