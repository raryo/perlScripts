#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;
use List::Util qw/max/;

my ($comp_fn, $deg_fn, $disop_fn) = @ARGV;

open my $comp, $comp_fn or die "$comp_fn can't be open:$!\n";
my %complex_of;
while (<$comp>){
    my ($comp_id, $mem) = split;
    my @mem = split ";", $mem;
    foreach my $gene (@mem){
        push @{$complex_of{$gene}}, $comp_id;
    }
}

open my $deg, $deg_fn or die "$comp_fn can't be open:$!\n";
my %deg_of;
while (<$deg>){
    my ($deg, $comp_id) = split ;
    $deg_of{$comp_id} = $deg;
}

open my $disop, $disop_fn or die "$disop_fn can't be open:$!\n";
while (<$disop>){
    my ($gene, $idr_cnt, $idr_len) = split;
    my $max_deg = max_deg(@{$complex_of{$gene}});
    say "$gene\t$idr_cnt\t$idr_len\t$max_deg";
}

sub max_deg {
    my @complexs = @_;
    my @degs;
    foreach my $c (@complexs){
        my $d = $deg_of{$c};
        push @degs, $d;
    }
    return max(@degs);
}
