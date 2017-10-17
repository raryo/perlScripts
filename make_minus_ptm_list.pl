#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my %subunit;
my %cnt_prot;

my @check_list = ("Phosphoprotein", "Glycoprotein", "Methylation",
    "Ubl conjugation", "Acetylation", "Polymorphism", "Membrane", "Transmembrane", "Signal", "Transcription", "Transcription regulation", "DNA-binding", "Transport", "Receptor" );

open SUB, "sed '1,5d' comp-list.dat|" or die "FNF1\n";
while (<SUB>){
    my ($id, @subunit) = split;
    $subunit{$id} = \@subunit;
}
close SUB;

my $input = shift;
open IN, $input or die "FNF\n";
my @prots_list; 
my @clust_ids;
while (<IN>){
    my ($i1, $i2, $j) = split;
    push @clust_ids, ($i1, $i2);
}
close IN;
my $tmp = &uniq(\@clust_ids);
@clust_ids = @$tmp;
foreach my $i (@clust_ids){
    push @prots_list, @{$subunit{$i}};
}
my $uniq_list = &uniq(\@prots_list);
say "prot Ph Gl Mt Ub Ac Pl Mm Tm Sg Ts Rg Dn Tr Rc";
foreach my $p (@$uniq_list){
    my $kw = &get_kw($p);
    my $bit_kw = &trans_bit($kw);
    say "$p $bit_kw";
}
#say "@$uniq_list";
#say "@clust_ids";

sub get_kw {#{{{
    my $g = shift @_;
    open KW, "KW_list.dat";
    my $kw_str;
    $/ = "\n";
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
