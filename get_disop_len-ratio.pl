#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my $file_n = shift;
open my $input, $file_n or die "$file_n not found. : $!\n";

while (<$input>){
    my ($gene, $len, $disop, $psipred) = split;
    my @regions = split ",", $disop;
    next unless $psipred;
    my ($sum, $max, $num_idr, $is_idp) = (0, 0, 0);
    foreach my $r (@regions){
        my $rlen = abs(eval $r);
        $sum += $rlen;
        $max =  $rlen if $rlen > $max;
        $num_idr++    if $rlen >= 70;
    }
    $is_idp = &det_idp($sum, $max, $num_idr, $len);
    print "$gene\t$len\t$sum\t$max\t$num_idr\t$is_idp\n";
}


sub det_idp {
    my ($sum, $max, $num_idr, $len) = @_;
    if ($sum/$len >= 0.5){
        return 1;
    }
    elsif ($num_idr > 0){
        return 1;
    }
    elsif ($max/$len >= 0.5){
        return 1;
    }
    else {
        return 0;
    }
}
