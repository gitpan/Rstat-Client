/* $Id: client.h,v 1.3 2002/05/26 12:09:10 schwenke Exp $ */

#ifndef CLIENT_H
#define CLIENT_H

#include "rstat.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef CPUSTATES
#  define CPUSTATES 4
#endif

#ifndef DK_NDRIVE
#  define DK_NDRIVE 4
#endif

/*
 * struct to hold an rstat_client Perl object
 */
typedef struct {
    CLIENT* clnt;  /* the RPC connection */
    int     debug; /* turns on extra messages */
} rstat_client;

/*
 * create an rstat_client structure on heap
 * create RPC connection from hostname
 * returns NULL on error
 */
rstat_client* rstat_create(char* host);

/*
 * fetch Rstatd record, version 3
 * printout if (self->debug != 0)
 * returns NULL on error
 */
statstime* rstat_fetch(rstat_client* self);

/*
 * destroy *clnt and rstat_client struct
 * print message if (self->debug != 0)
 */
void rstat_destroy(rstat_client* self);

#ifdef __cplusplus
}
#endif


#endif /* CLIENT_H */
