# $Id: Makefile.PL,v 1.4 2002/05/26 12:09:10 schwenke Exp $

use ExtUtils::MakeMaker;

my $RSTAT_X   = "/usr/include/rpcsvc/rstat.x";
my $RPCGEN_OK = 0;

#
# try to create RPC/rstat stub code via rpcgen
#
{
    unless (-r $RSTAT_X) {
        print "OOPS: you don't have $RSTAT_X\n";
        last;
    }
    print "OK: you have $RSTAT_X ...\n";

    system "cp $RSTAT_X .";
    if ($? >> 8) {
        print "OOPS: couldn't copy $RSTAT_X : $!\n";
        last;
    }
    print "OK: copied $RSTAT_X\n";

    system "rpcgen rstat.x";
    if ($? >> 8) {
        print "OOPS: error running rpcgen : $!\n";
        last;
    }
    print "OK: rpcgen successful\n";

    unless (-r "./rstat.h") {
        print "OOPS: missing ./rstat.h\n";
        last;
    }

    unless (-r "./rstat_clnt.c") {
        print "OOPS: missing ./rstat_clnt.c\n";
        last;
    }

    unless (-r "./rstat_xdr.c") {
        print "OOPS: missing ./rstat_xdr.c\n";
        last;
    }

    eval { unlink "./rstat.x" };
    eval { unlink "./rstat_svc.c" };

    $RPCGEN_OK = 1;
}


#
# default: use delivered stub code
#
unless ($RPCGEN_OK) {
    print "INFO: using my rstat implementation\n";
    link "rstat.h.in", "rstat.h"
    and link "rstat_xdr.c.in", "rstat_xdr.c"
    and link "rstat_clnt.c.in", "rstat_clnt.c"
    or die "OOPS: could not create rstat stub code : $!\n";
}


WriteMakefile(
    'AUTHOR'       => 'Axel Schwenke <axel.schwenke@gmx.net>',
    'NAME'	   => 'Rstat::Client',
    'VERSION_FROM' => 'Client.pm',
    'OBJECT'       => 'Client$(OBJ_EXT) client$(OBJ_EXT) pack$(OBJ_EXT) ' .
                      'rstat_clnt$(OBJ_EXT) rstat_xdr$(OBJ_EXT)',
    'LIBS'	   => ['-lnsl'],
    'XSPROTOARG'   => '-noprototypes',
    'clean'        => {'FILES' => 'rstat.h rstat_clnt.c rstat_xdr.c'}
);

