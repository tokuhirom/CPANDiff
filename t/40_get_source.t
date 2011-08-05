use strict;
use warnings;
use utf8;
use Test::More;

use CPANDiff::API;

# http://api.metacpan.org/source/OVID/Text-Diff-1.41/README

my $api = CPANDiff::API->instance;
my $source = $api->get_source(
    author  => 'OVID',
    release => 'Text-Diff-1.41',
    path    => 'README'
);
like $source, qr{SYNOPSIS};

done_testing;

