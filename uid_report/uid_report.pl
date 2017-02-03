#!/usr/bin/env perl

# Written by: Matt Hersant

use strict;
use Data::Dumper;

my @lines = `getent passwd`;

my %struct;
for my $line (@lines) {
    my @items = split /:/, $line;
    my $uid = $items[2];
    $struct{$uid} = \@items;
}

for my $uid (sort keys %struct) {
    if ($uid >= 100) {
        print join(':', @{$struct{$uid}});
    }
}
