# $Id: Client.pm,v 1.4 2002/05/26 12:09:51 schwenke Exp $

package Rstat::Client;

use strict;
use vars qw($VERSION @ISA);

require DynaLoader;

@ISA = qw(DynaLoader);
$VERSION = '1.02';

bootstrap Rstat::Client $VERSION;

1;
__END__

=head1 NAME

Rstat::Client - Perl extension for client access to rstatd

=head1 SYNOPSIS

use Rstat::Client;

$clnt  = Rstat::Client->new("some.host")

$stats = $clnt->fetch();

S<printf "CPU Load: %.2f %.2f %.2f\n", @{$stats->{'avenrun'}};>

=head1 DESCRIPTION

This tiny Perl extension gives you access to rstatd statistics.
First create an C<Rstat::Client> object:

$clnt = Rstat::Client->new($hostname);

The parameter C<$hostname> is optional and defaults to localhost.

Fetch statistic records by calling the C<fetch()> method of the
C<Rstat::Client> object:

$stats = $clnt->fetch();

C<fetch()> returns a reference to a hash containing the numbers.
Hash keys follow the names from my F</usr/include/rpcsvc/rstat.x>.

=head1 DATA FORMAT

Here is a commented C<Data::Dumper> dump of the stats hash:

$stats = {
          #time when this record was fetched
          'curtime.tv_sec' => '1021885390',
          'curtime.tv_usec' => 181205,

          #time when the system was booted
          'boottime.tv_sec' => '1021781411',
          'boottime.tv_usec' => '0',

          #pages swapped in/out
          'v_pswpin' => 1,
          'v_pswpout' => '0',

          #pages paged in/out
          'v_pgpgin' => 43155,
          'v_pgpgout' => 64266,

          #interrupts and context switches
          'v_intr' => 11150229,
          'v_swtch' => 23174363,

          #network statistics (sum over all interfaces)
          'if_ipackets' => 43238686,
          'if_ierrors' => 71633,
          'if_opackets' => '87451',
          'if_oerrors' => '0',
          'if_collisions' => 0,

          #run queue length (1/5/15 minutes average)
          'avenrun' => [
                         '0.45703125',
                         '0.21875',
                         '0.13671875'
                       ]

          #cpu time (in ticks) for USER/NICE/SYS/IDLE
          'cp_time' => [
                         261982,
                         11,
                         450845,
                         9685071
                       ],

          #disk transfers
          'dk_xfer' => [
                         47053,
                         '0',
                         '0',
                         '0'
                       ],
        };

=head2 NOTES

Timestamps are separated into seconds (standard UNIX time) and
microseconds. The availability of a current timestamp allows proper
calculation of the interval between measurements without worrying
about network latency.

Most values are counters. To get the real numbers you have to
C<fetch()> samples regularly and divide the counter increments
by the time interval between the samples.

The C<cpu_time> array holds the ticks spent in the various CPU states
(averaged over all CPUs). If you know the regular tick rate of the target
system you may calculate the number of CPUs from the sum of C<cpu_time>
increments and the time interval between the samples. Most often you
will be interested in the percentage of CPU states only.

The C<avenrun> array is originally shifted by 8 bits. The XS glue code
takes care of this and reports floating point values to Perl.

=head1 PORTABILITY

This package should compile on almost any UNIX system. F<rpcgen> and
F</usr/include/rpcsvc/rstat.x> will be used to create platform specific
RPC/rstat stub code. If this is not possible, my stub code (created
by rpcgen on my Linux box) will be used.

The package is known to compile on Linux, Solaris 7/8 and HPUX 11.
My intention is to make this package as portable as possible. Please
report any portability issues to me!

=head1 BUGS AND DESIGN LIMITATIONS

For portability reasons this package uses version 3 (RSTATVERS_TIME)
of the rstatd protocol. Version 4 adds dynamically sized arrays for CPU
state and disk access but was not available on all targeted plattforms.

As any software this package may contain bugs. Please feel free to
contact me if you find one.

=head1 AUTHOR

Axel Schwenke <axel.schwenke@gmx.net>

Copyright (c) 2002 Axel Schwenke. All rights reserved.  This program is
free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

=head1 VERSION

Version 1.01 (22 May 2002)

=head1 SEE ALSO

L<rstatd(8)>.

=cut
