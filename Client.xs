/* $Id: Client.xs,v 1.2 2002/05/22 11:03:39 schwenke Exp $ */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "client.h"
#include "pack.h"


MODULE = Rstat::Client		PACKAGE = Rstat::Client

rstat_client*
new(CLASS, host = "localhost")
    char* CLASS;
    char* host;
CODE:
    RETVAL = rstat_create(host);
    if (RETVAL == 0) {
        warn("Rstat::Client::new(): failed");
        XSRETURN_UNDEF;
    }
OUTPUT:
    RETVAL


void
DESTROY(self)
    rstat_client* self;
CODE:
    rstat_destroy(self);


statstime*
fetch(self)
    rstat_client* self;
CODE:
    RETVAL = rstat_fetch(self);
    if (RETVAL == 0) {
        warn("Rstat::Client::fetch(): failed");
        XSRETURN_UNDEF;
    }
OUTPUT:
    RETVAL


void
debug(self,val)
    rstat_client* self;
    int val;
CODE:
    self->debug = val;

