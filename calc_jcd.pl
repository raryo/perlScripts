#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my $comp_list_file = $ARGV[0];

# prepare hash of complex_id and its subunits.
open REF, $comp_list_file or die $!, ": $comp_list_file";
my %List;
while (<REF>){
    my ($id, @subunits) = split;
    $List{$id} = \@subunits;
}
close REF;

open IN, $comp_list_file or die $!, ": $comp_list_file";
while (<IN>){
    my ($comp_id, @subunits) = split;
    my $connected = &find_comp($comp_id);
    # print connected complexes.
    foreach my $c (@$connected){
        my ($id, $jcd) = ($c->{'id'}, $c->{'jcd'});
        printf "%s\t%s\t%4.3f\n", $comp_id, $id, $jcd;
    }
}

# find complexes which have common proteins.
# return an array_ref which has hash_ref of {id, jcd}.
sub find_comp {
    my $id_self = shift @_;
    my $connected;
    foreach my $id_subject (keys %List){
        next if $id_subject eq $id_self;
        my $sub_self = $List{$id_self};
        my $sub_subject = $List{$id_subject};
        my $jcd = &calc_jcd($sub_self, $sub_subject);
        if ($jcd){
            my %tmp;
            @tmp{'id', 'jcd'} = ($id_subject, $jcd);
            push @$connected, \%tmp;
        }
    }
    return $connected;
}

# calculate Jaccard index.
sub calc_jcd {#{{{
    my ($ref1, $ref2) = @_;
    my @arr1 = @$ref1;
    my @arr2 = @$ref2;
    # label if therer are same prots
    &labeling(\@arr1);
    &labeling(\@arr2);

    my %cnt;
    # define AND set
    my @AND = grep{ ++$cnt{$_} > 1 } (@arr1, @arr2);
    # if AND set is null, return 0.
    if (!@AND) { return 0; }
    # define OR set
    my @OR  =  keys %cnt;
    return scalar @AND / scalar @OR;    
}#}}}

# if a complex have more than 2 same subunits, distinguish them.
# e.g. COMP_1={a, a, b, c} => COMP_1={a1, a2, b, c}.
sub labeling {#{{{
    my $arr = shift @_;
    my ($prev, $i, $last);
    foreach  (@$arr){
        if ($prev eq $_){
            if ($last ne $_){
                $i = 1;
                $last = $_;
            }
            $_ = $_ . $i;
            $i++;
        }
        else {
            $prev = $_;
        } 
    }
}#}}}
