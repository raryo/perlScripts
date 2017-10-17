#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;
use Data::Dumper;




my $edge_file = shift;
open EDGE, "awk '\$1<\$2' $edge_file|" or die "can't open :$!";
my %Edge;
while (<EDGE>){
    my ($a, $b, $jcd) = split;
    push @{$Edge{$jcd}}, $a.'-'.$b;
}
close EDGE;

my @All_clusters; # list of ref to each cluster.


my $Prev_jcd = 1.0;
foreach my $j (keys %Edge){
    my @edges = sort @{$Edge{$j}};
    foreach my $e (@edges){
        &add_cluster($e, $j, $Prev_jcd);
        $Prev_jcd = $j;
    }
}
&myprint(\@All_clusters);

sub add_cluster {#{{{
    my ($new_edge, $jcd, $prev_jcd) = @_;
    my ($node_a, $node_b) = split '-', $new_edge;
    my $id_included_a = -1;
    my $id_included_b = -1;
    while (my ($clstr_id, $clstr) = each @All_clusters){
        my $member = &get_member($clstr);
        foreach my $c_m (@$member){
            if ($c_m eq $node_a){
                $id_included_a = $clstr_id;
            }
            if ($c_m eq $node_b){
                $id_included_b = $clstr_id;
            }
            last if $id_included_a >= 0 and $id_included_b >= 0;
        }
    }
    
    if ($id_included_a >= 0 and $id_included_b >= 0 ){
        if ($id_included_a == $id_included_b){
            # the $new_edge is included the same cluster.
            if ($jcd == $prev_jcd){
                push @{$All_clusters[$id_included_a]}, $new_edge;
            }
        } 
        else {
            # merge two clusters.
            my @merged = (@{$All_clusters[$id_included_a]}, @{$All_clusters[$id_included_b]});
            push @merged, $new_edge;
            $All_clusters[$id_included_a] = \@merged;
            splice @All_clusters, $id_included_b, 1;
        }
    }
    elsif ($id_included_a >= 0 or $id_included_b >= 0){
        my $include_id = $id_included_a >= 0 ? 
                         $id_included_a : $id_included_b;
        push @{$All_clusters[$include_id]}, $new_edge;
    } 
    else {
        my @tmp;
        push @tmp, $new_edge;
        push @All_clusters, \@tmp;
    } 
}#}}}

sub get_member {
    my $clstr_ref = shift;
    my %tmp_member_hash;
    foreach  (@$clstr_ref){
        my ($a, $b) = split '-';
        $tmp_member_hash{$a}++;
        $tmp_member_hash{$b}++;
    }
    my @all_member = keys %tmp_member_hash;
    return \@all_member;
}

sub myprint{
    my $var = shift;
    #local $Data::Dumper::Deparse = 1;
    #print Data::Dumper::Dumper $var;
    my @clusters = @$var;
    foreach my $c (@clusters){
        my @member = @$c;
        $" = "\n";
        print "@member";
        print "\n\n";
    }
}
