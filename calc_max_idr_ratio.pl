#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my ($comp_f, $disop_f, $deg_f) = @ARGV;

open my $disop, $disop_f or die "file not founc $disop_f : $!\n";
my %idrt_of;
while (<$disop>){
    my ($gene, $idratio) = split;
    $idrt_of{$gene} = $idratio;
}
close $disop;

open my $deg, $deg_f or die "file not found $deg_f : $!\n";
my %deg_of;
while (<$deg>){
    my ($comp_id, $degree) = split;
    $deg_of{$comp_id} = $degree;
}
close $deg;

open my $comp, $comp_f or die "file not found $comp_f : $!\n";
while (<$comp>){
    my ($comp_id, $sub_str) = split;
    my @sub = split ";", $sub_str;
    my $max_idrt = 0;
    foreach my $s (@sub){
        my $idrt = $idrt_of{$s};
        $max_idrt = $idrt if $idrt > $max_idrt;
    }
    my $degree = $deg_of{$comp_id} ? $deg_of{$comp_id} : 0;
    say "$comp_id\t$max_idrt\t$degree";
}
close $comp;
