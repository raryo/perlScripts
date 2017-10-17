#!/usr/bin/perl
# vim:set foldmethod=marker:
use strict;
use 5.10.0;

my $file = shift;
open my $input, $file or die "File $file not fonund.:$!";

my ($gene_id, $swis_ac, $disop, $diso, $len);
while (<$input>){
    if (/SW:GN\s+Name=([\w\-]+);*+/){
        $gene_id = $1;
    }
    if (/SW:AC\s+(\w+)/){
        $swis_ac = $1;
    }
    if (/DISOP:\w+\s+([^\s]+)/){
        $disop = $1;
    }
    if (/DISORD\s+([^\s]+)/){
        $diso = $1;
    }
    if (/LENGTH\s+(\d+)/){
        $len = $1;
    }

}
say "$gene_id\t$len\t$disop\t$diso";
