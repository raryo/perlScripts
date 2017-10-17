#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my @KW = ("Phosphoprotein", "Glycoprotein", "Methylation",
    "Ubl conjugation", "Acetylation", "Polymorphism", "Membrane", "Transmembrane", "Signal", "Transcription", "Transcription regulation", "DNA-binding", "Transport", "Receptor" );

open IN, "fisher_table.dat" or die "FNF\n";
my $n = 0;
while (<IN>){
    chomp;
    my @res = `Rscript fisher.R $_`;
    say $KW[$n++];
    &parse(\@res, $_);
}
close IN;

sub parse {
    my $res = shift;
    my ($ih, $id, $oh, $od) = split ' ', shift;
    my ($s, $e, $p_val) = split ' ', $$res[4];
    my $in_have  = &round(3, $ih / ($ih + $id));
    my $out_have = &round(3, $oh / ($oh + $od));
    if ($p_val <= 0.05){
        if ($in_have > $out_have){
            print "+ $p_val";
        }
        else {
            print "- $p_val";
        } 
        say " $in_have $out_have";
    } 
    else {
        print "x $p_val";
        say " $in_have $out_have";
    } 
}

sub round {
    my $col = shift;
    my $val = shift;
    my $r = 10 ** $col;
    my $a = ($val > 0) ? 0.5 : -0.5;
    return int($val * $r + $a) / $r;
}
