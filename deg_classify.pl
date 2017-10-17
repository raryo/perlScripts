#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my $file = shift;

open my $input, $file or die "File not found. $file : $!\n";
while (<$input>){
    my ($cid, $ratio, $deg) = split;
    my $cls = classify($deg);
    say "$cid\t$ratio\t$cls";
}

sub classify {
    my $var = shift;
    my $cls = int($var / 10);
    return $cls;
}
