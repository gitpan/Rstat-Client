/* $Id: client.c,v 1.1 2002/05/22 11:02:16 schwenke Exp $ */

#include "client.h"


rstat_client* rstat_create(char* host)
{
    rstat_client* self = (rstat_client*) malloc(sizeof(rstat_client));
    if (self == NULL)
        return NULL;
    self->clnt = clnt_create (host, RSTATPROG, RSTATVERS_TIME, "udp");
    if (self->clnt == NULL) {
        clnt_pcreateerror (host);
        free(self);
        return NULL;
    }
    self->debug = 0;
    return self;
}


statstime* rstat_fetch(rstat_client* self)
{
    statstime* result_1;
    u_int*     result_2;
    char*      rstatproc_stats_3_arg;
    char*      rstatproc_havedisk_3_arg;
    int        i;

    result_1 = rstatproc_stats_3((void*)&rstatproc_stats_3_arg, self->clnt);
    if (result_1 == (statstime *) NULL) {
        clnt_perror (self->clnt, "call failed");
    }
    result_2 = rstatproc_havedisk_3((void*)&rstatproc_havedisk_3_arg, self->clnt);
    if (result_2 == (u_int *) NULL) {
        clnt_perror (self->clnt, "call failed");
    }

    if (self->debug) {
        printf("pgpgin: %d pgpgout: %d  pswpin: %d  pswpout: %d\n",
               result_1->v_pgpgin, result_1->v_pgpgout,
               result_1->v_pswpin, result_1->v_pswpout);
        printf("intr: %d  swtch: %d  avenrun: %3.1f %3.1f %3.1f\n",
               result_1->v_intr, result_1->v_swtch, result_1->avenrun[0]/256.0,
               result_1->avenrun[1]/256.0, result_1->avenrun[2]/256.0);
        printf("ipackets: %d  ierrors: %d  opackets: %d  oerrors: %d  collisions: %d\n",
               result_1->if_ipackets, result_1->if_ierrors, result_1->if_opackets,
               result_1->if_oerrors, result_1->if_collisions);
        printf("usr: %d sys: %d  wio: %d  idle: %d\n", result_1->cp_time[0],
               result_1->cp_time[2], result_1->cp_time[1], result_1->cp_time[3]);
        for(i=0; i < DK_NDRIVE; i++) {
            printf("disk: %d  xferesult_1: %d\n", i, result_1->dk_xfer[i]);
        }
    }

    return result_1;
}


void rstat_destroy(rstat_client* self)
{
    if (self->debug) {
        printf("rstat_destroy(%p)\n", self);
    }
    clnt_destroy (self->clnt);
    free(self);
}

