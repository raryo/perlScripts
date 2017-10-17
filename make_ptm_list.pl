#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my %kw_rank;
my %subunit;
my @prots_list;
my %cnt_prot;

my @check_list = ("Phosphoprotein", "Glycoprotein", "Methylation",
    "Ubl conjugation", "Acetylation", "Polymorphism", "Membrane", "Transmembrane", "Signal", "Transcription", "Transcription regulation", "DNA-binding", "Transport", "Receptor" );

open SUB, "corum_comp_list.dat" or die "FNF1\n";
while (<SUB>){
    my ($id, $sub_str) = split;
    my @subunits = split ";", $sub_str;
    $subunit{$id} = \@subunits;
}
close SUB;

my $input = shift;
unless ($input eq "hub" or $input eq "terminal"){ die "1st arg is hub or terminal." }
open DEG, $input."_list.dat" or die "FNF2\n";
while (<DEG>){
    my ($id, $deg) = split;
    push @prots_list, @{$subunit{$id}};
}
close DEG;

open OUT, ">".$input."_ptm_list.dat";
say OUT "prot Ph Gl Mt Ub Ac Pl Mm Tm Sg Ts Rg Dn Tr Rc";
my $uniq_list = &uniq(\@prots_list);
foreach my $p (@$uniq_list){
    my $kw = &get_kw($p);
    my $bit_kw = &trans_bit($kw);
    say OUT "$p $bit_kw";
}
close OUT;

sub get_kw {#{{{
    my $g = shift @_;
    open KW, "KW_list.dat";
    my $kw_str;
    while (<KW>){
        my ($gene_id, @kw) = split;
        if ($g eq $gene_id){
            $kw_str = join " ", @kw;
            last;
        }
    }
    close KW;
    my @kw_list = split ";", $kw_str;
    return \@kw_list;
}#}}}

sub trans_bit {#{{{
    my $kw = shift;
    my %kw_bit;
    $kw_bit{$_} = 0 foreach (@check_list);
    $kw_bit{$_}++ foreach (@$kw);
    my $str_kw;
    $str_kw .= $kw_bit{$_} . " " foreach (@check_list);
    return $str_kw;
}#}}}

sub uniq {#{{{
    my $arr = shift @_;
    my %cnt;
    my @uniq = grep { !$cnt{$_}++ } @$arr;
    return \@uniq;
}#}}}

sub check_is_include {#{{{
    my $que_kw = shift;
    #my @check_list = ("Polymorphism", "Membrance", "Phosphoprotein",
    #    "Transmembrane", "Acetylation", "Signal", "Transcription",
    #    "Transcription regulation");
    #my @check_list = ("Phosphoprotein", "Glycoprotein", "Methylation",
    #    "Ubl conjugation", "Acetylation" );
    foreach  (@check_list){
        if ($que_kw eq $_){
            return 1;
        }
    }
    return 0;
}#}}}
