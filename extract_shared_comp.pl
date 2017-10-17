#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;
use File::Slurp;

my @CORUM = read_file 'corum_comp_list.dat';
my @HPRD  = read_file ('hprd_comp_list.dat');
#my @CORUM = read_file ('test1.dat');
#my @HPRD  = read_file ('test2.dat');

# cut header
shift @HPRD;
my %Cnt_comp;

my %corum_id_of;
foreach my $c (@CORUM){
    my ($id, $mem) = split ' ', $c;
    my @mem = sort (split ';', $mem);
    $mem = join '@', @mem;
    $Cnt_comp{$mem} += 1;
    $corum_id_of{$mem} = $id;
}

my %hprd_id_of;
foreach my $c (@HPRD){
    my ($id, @mem) = split ' ', $c;
    @mem = sort @mem;
    my $mem = join '@', @mem;
    $Cnt_comp{$mem} += 1000;
    $hprd_id_of{$mem} = $id;
}

#foreach  (keys %Cnt_comp){
#    # // gives default value.
#    my $corum_id = $corum_id_of{$_} // '';
#    my $hprd_id  = $hprd_id_of{$_}  // '';
#    my $id;
#    if    ($corum_id eq ''){ $id = $hprd_id  }
#    elsif ($hprd_id  eq ''){ $id = $corum_id }
#    else { $id = $corum_id . "/" . $hprd_id  }
#    say "$Cnt_comp{$_}\t$id\t$_\n";
#}

open my $hprd_out, ">hprd_comp_std.dat";
open my $corum_out, ">corum_comp_std.dat";

print $hprd_out  "$_," foreach (keys %hprd_id_of);
print $corum_out "$_," foreach (keys %corum_id_of);
