#!/usr/bin/perl -w

use ExtUtils::testlib;
use Rstat::Client;

my $clnt  = Rstat::Client->new();
my $stats = $clnt->fetch();
printf("CPU Load: %.2f %.2f %.2f\n", @{$stats->{avenrun}});

