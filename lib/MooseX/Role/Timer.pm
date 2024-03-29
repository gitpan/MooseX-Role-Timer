package MooseX::Role::Timer;
{
  $MooseX::Role::Timer::VERSION = '0.04';
}

use Any::Moose '::Role';
use Time::HiRes;
use strict;
use warnings;

=head1 NAME

MooseX::Role::Timer - Measure times with your object.

=head1 SYNOPSIS

 package Demo;
 use Moose; # or Any::Moose
 with 'MooseX::Role::Timer';

 sub BUILD {
   shift->start_timer("build");
 }

 sub do_something {
   my $self = shift;
   $self->start_timer("something");
   # do something...
   $self->stop_timer("something");
 }

 package main;
 my $demo = Demo->new;
 $demo->do_something;
 $demo->do_something;
 printf "%3.6fs\n", $demo->elapsed_timer("build");     # time spent since BUILD
 printf "%3.6fs\n", $demo->elapsed_timer("something"); # time spent in sub do_something

This Role provides your object with timers, making it easier to keep track of how long 
whatever actions take.

=cut

has '_timers' => ( is=>'rw', isa=>'HashRef', default=>sub{{}} );

=over 4

=item start_timer($name)

Start timer $name.

=cut

sub start_timer {
    my $self = shift;
    my $name = shift || die "usage: start_timer('name')";
    if ( ! exists $self->_timers->{$name} ) {
        $self->_timers->{$name} = [0];
    }
    $self->_timers->{$name}->[1] = [ Time::HiRes::gettimeofday ];
}

=item stop_timer($name)

Stop timer $name. Could be started again to cumulatively measure time.

=cut

sub stop_timer {
    my $self = shift;
    my $name = shift || die "usage: stop_timer('name')";
    my $timer = $self->_timers->{$name};
    if ( $timer->[1] ) {
        $timer->[0] += Time::HiRes::tv_interval( $timer->[1] );
        $timer->[1] = undef;
    } else {
        warn "timer '$name' is not running";
    }
}

=item reset_timer($name)

Stops timer $name and clears cumulated times for $name.

=cut

sub reset_timer {
    my $self = shift;
    my $name = shift || die "usage: reset_timer('name')";
    $self->_timers->{$name} = [0];
}

=item elapsed_timer('name')

Return the elapsed time in seconds (cumulated) for timer $name.

=cut

sub elapsed_timer {
    my $self = shift;
    my $name = shift || die "usage: elapsed_timer('name')";
    die "timer '$name' was never started" if ! exists $self->_timers->{$name};
    my $elapsed = $self->_timers->{$name}->[0];
    if ( $self->_timers->{$name}->[1] ) {
        $elapsed += Time::HiRes::tv_interval( $self->_timers->{$name}->[1] );
    }
    return $elapsed;
}

=item timer_names

Return all timer names.

=cut

sub timer_names {
    return keys %{ shift->_timers };
}

=back

=head1 AUTHOR

Michael Langner, C<< <mila at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-moosex-role-timer at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Role-Timer>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2014 Michael Langner, all rights reserved.

This program is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

=cut

1; # track-id: 3a59124cfcc7ce26274174c962094a20
