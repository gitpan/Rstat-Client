/* $Id: pack.h,v 1.4 2002/05/26 12:09:10 schwenke Exp $ */

#ifndef PACK_H
#define PACK_H

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "client.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * pack a statstime struct into a Perl hash
 */
extern void XS_pack_statstimePtr(SV* st, statstime *stats);

#ifdef __cplusplus
}
#endif

#endif /* PACK_H */
