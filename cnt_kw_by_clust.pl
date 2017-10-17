#!/usr/bin/perl
use strict;
use 5.10.0;

my $input = shift;
open IN, $input or die "FNF\n";
my @header = split ' ', <IN>;
my @kw = @header[1..$#header];
my %sum;
while (<IN>){
    my ($gene, @bit) = split;
    my %kw_bit;
    for (my $i=0; $i<=$#bit; $i++){
        $kw_bit{$kw[$i]} = $bit[$i];
    }
    foreach my $k (@kw){
        $sum{$k} += $kw_bit{$k};
    }
}
close IN;

for (my $i=0; $i<=$#kw; $i++){
    say $sum{$kw[$i]};
}
