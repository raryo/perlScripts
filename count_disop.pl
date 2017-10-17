#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

#my $name = shift;
#open $input, $name or die "$name can't be found:$!";

#while (<$input>){
while (<STDIN>){
    my ($id, $disop) = split;
    my @idr = split ',', $disop;
    
    my $count_all = $#idr + 1;
    my $length_all;
    foreach my $r (@idr){
        $length_all += abs(eval $r) + 1;
    }
    say "$id\t$count_all\t$length_all";
}
