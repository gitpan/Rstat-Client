#!/usr/bin/perl -w

use Data::Dumper;
use ExtUtils::testlib;
use Rstat::Client;

my $clnt  = Rstat::Client->new();
my $stats = $clnt->fetch();
print Dumper($stats);

