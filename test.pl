# $Id: test.pl,v 1.4 2002/05/22 11:03:40 schwenke Exp $

BEGIN { $| = 1; print "1..4\n"; }
END {print "not ok 1\n" unless $loaded;}
use Rstat::Client;
$loaded = 1;
print "ok 1\n";

print rstat_new()     ? "ok 2" : "not ok 2", "\n";
print rstat_fetch()   ? "ok 3" : "not ok 3", "\n";
print rstat_destroy() ? "ok 4" : "not ok 4", "\n";


sub rstat_new
{
    $rstat = Rstat::Client->new();
    return defined $rstat;
}


sub rstat_fetch
{
    my $stats = $rstat->fetch();
    return 0 unless defined $stats;
    my $nkey = scalar keys %$stats;
    return 0 unless $nkey == 18;
    return 1;
}


sub rstat_destroy
{
    undef $rstat;
    return not defined $rstat;
}

