/* $Id: pack.c,v 1.2 2002/05/26 12:09:10 schwenke Exp $ */

#include "pack.h"

#define STORE_IV(name) \
    sv = newSViv(stats->name);\
    if (hv_store(hv, #name, sizeof(#name)-1, sv, 0) == NULL) {\
        warn("XS_pack_statstimePtr: failed to store '" ## #name ## "' elem");\
    }\

#define STORE_RV(name) \
        sv = newRV_noinc((SV*)av);\
        if (hv_store(hv, #name, sizeof(#name)-1, sv, 0) == NULL) {\
            warn("XS_pack_statstimePtr: failed to store '" ## #name ## "' elem");\
        }\

void XS_pack_statstimePtr(SV* st, statstime *stats)
{
    HV *hv = newHV();
    SV *sv;

    /* put scalar statstime components into hash */
    STORE_IV(v_pgpgin);
    STORE_IV(v_pgpgout);
    STORE_IV(v_pswpin);
    STORE_IV(v_pswpout);
    STORE_IV(v_intr);
    STORE_IV(v_swtch);
    STORE_IV(if_ipackets);
    STORE_IV(if_ierrors);
    STORE_IV(if_opackets);
    STORE_IV(if_oerrors);
    STORE_IV(if_collisions);
    STORE_IV(boottime.tv_sec);
    STORE_IV(boottime.tv_usec);
    STORE_IV(curtime.tv_sec);
    STORE_IV(curtime.tv_usec);

    {   /* put array avenrun[] into hash */
        AV *av = newAV();
        av_push(av, newSVnv(stats->avenrun[0]/256.0));
        av_push(av, newSVnv(stats->avenrun[1]/256.0));
        av_push(av, newSVnv(stats->avenrun[2]/256.0));
        STORE_RV(avenrun);
    }
    {   /* put array cp_time[] into hash */
        AV *av = newAV();
        int i;
        for (i = 0; i < CPUSTATES; i++) {
            av_push(av, newSViv(stats->cp_time[i]));
        }
        STORE_RV(cp_time);
    }
    {   /* put array dk_xfer[] into hash */
        AV *av = newAV();
        int i;
        for (i = 0; i < DK_NDRIVE; i++) {
            av_push(av, newSViv(stats->dk_xfer[i]));
        }
        STORE_RV(dk_xfer);
    }

    /* put ref to hash onto stack */
    sv = newSVrv(st, NULL);
    SvREFCNT_dec(sv);
    SvRV(st) = (SV*)hv;
}

