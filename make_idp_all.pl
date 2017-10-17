#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my ($list_f, $comp_f) = @ARGV;

open my $prots, $list_f or die "file1 $list_f not found. \n";
my %prot;
while (<$prots>){
    my @cols = split;
    my $gene = shift @cols;
    ($prot{$gene}{'len'}, 
     $prot{$gene}{'sum'}, 
     $prot{$gene}{'longest'}, 
     $prot{$gene}{'num_idr'}, 
     $prot{$gene}{'is_idp'}) = @cols;
     $prot{$gene}{'ratioSum'}     = $prot{$gene}{'sum'}     / $prot{$gene}{'len'};
     $prot{$gene}{'ratioLongest'} = $prot{$gene}{'longest'} / $prot{$gene}{'len'};
}
close $prots;

open my $comp, $comp_f or die "file2 $comp_f not found. \n";
print "comp_id\tlongestmax-idr_in_complex\tsum_of_max-idr\tmax-sum_in_comples\tsum_of_idr\tmax-num_in_complex\tsum_of_num\tnum_idp\tmax-sum/comp-len\tmax-longest/comp-len\tcomp-len\tratio_idp\n";
while (<$comp>){
    my ($comp_id, $gene_str) = split;
    my @subunits = split ";" , $gene_str;
    my @outparam;
    my @func_refs = (\&get_total_longest_idrlen, \&get_sum_longest_idrlen,
                     \&get_longest_sum_idrlen,   \&get_total_sum_idrlen,
                     \&get_highest_num_idr,      \&get_sum_num_idr,
                     \&get_num_idp,              \&get_highest_ratioSum,
                     \&get_longest_ratioLongest, \&get_complex_len,
                     \&get_ratio_idp);
    foreach my $f (@func_refs){
       push @outparam, $f->(@subunits); 
    }
    unshift @outparam, $comp_id;
    $" = "\t";
    print "@outparam\n";
}

sub get_total_longest_idrlen {#{{{
    my @subunits = @_;
    my $longest = 0;
    foreach my $s (@subunits){
        $longest = $prot{$s}{'longest'} if $prot{$s}{'longest'} > $longest;
    }
    return $longest;
}#}}}

sub get_sum_longest_idrlen {#{{{
    my @subs = @_;
    my $sum_longest = 0;
    foreach my $s (@subs){
        $sum_longest += $prot{$s}{'longest'};
    }
    return $sum_longest;
}#}}}

sub get_longest_sum_idrlen {#{{{
    my @subs = @_;
    my $longest_sum_idrlen = 0;
    foreach my $s (@subs){
        $longest_sum_idrlen = $prot{$s}{'sum'} if $prot{$s}{'sum'} > $longest_sum_idrlen;
    }
    return $longest_sum_idrlen;
}#}}}

sub get_total_sum_idrlen {#{{{
    my @subs = @_;
    my $sum_idrlen = 0;
    foreach my $s (@subs){
        $sum_idrlen += $prot{$s}{'sum'};
    }
    return $sum_idrlen;
}#}}}

sub get_highest_num_idr {#{{{
    my @subs = @_;
    my $highest_num_idr = 0;
    foreach my $s (@subs){
        $highest_num_idr = $prot{$s}{'num_idr'} if $prot{$s}{'num_idr'} > $highest_num_idr;
    }
    return $highest_num_idr;
}#}}}

sub get_sum_num_idr {#{{{
    my @subs = @_;
    my $sum_num_idr = 0;
    foreach my $s (@subs){
        $sum_num_idr += $prot{$s}{'num_idr'};
    }
    return $sum_num_idr;
}#}}}

sub get_num_idp {#{{{
    my @subs = @_;
    my $num_idp = 0;
    foreach my $s (@subs){
        $num_idp += $prot{$s}{'is_idp'};
    }
    return $num_idp;
}#}}}

sub get_highest_ratioSum {#{{{
    my @subs = @_;
    my $highest_ratio = 0;
    foreach my $s (@subs){
        $highest_ratio = $prot{$s}{'ratioSum'} if $prot{$s}{'ratioSum'} > $highest_ratio;
    }
    return $highest_ratio;
}#}}}

sub get_longest_ratioLongest {#{{{
    my @subs = @_;
    my $longest = 0;
    foreach my $s (@subs){
        $longest = $prot{$s}{'ratioLongest'} if $prot{$s}{'ratioLongest'} > $longest;
    }
    return $longest;
}#}}}

sub get_complex_len {#{{{
    my @subs = @_;
    my $all_len = 0;
    foreach my $s (@subs){
        $all_len += $prot{$s}{'len'};
    }
    return $all_len;
}#}}}

sub get_ratio_idp {#{{{
    my @subs = @_;
    my $ratio_idp = 0;
    my $ratio_idp = &get_num_idp(@subs) / ($#subs + 1);
    return $ratio_idp;
}#}}}

