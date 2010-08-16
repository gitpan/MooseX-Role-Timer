#!/usr/bin/env perl

use Test::More tests => 4;
use warnings;
use strict;

package Demo;
use Time::HiRes 'usleep';
use Moose;

with 'MooseX::Role::Timer';

sub BUILD {
    shift->start_timer("build");
}

sub a {
    my $self = shift;
    $self->start_timer("a");
    usleep(3_000);
    $self->stop_timer("a");
}

sub b {
    my $self = shift;
    $self->start_timer("b");
    usleep(4_000);
    $self->stop_timer("b");
}

package main;

my $demo = Demo->new;

for (0..4) {
    $demo->a;
    $demo->b;
}

ok( $demo->elapsed_timer("a") > 0, "a>0" );

ok( $demo->elapsed_timer("b") > 0, "b>0" );

ok( $demo->elapsed_timer("b") > $demo->elapsed_timer("a"), "b>a" );

ok( $demo->elapsed_timer("build") > $demo->elapsed_timer("a") + $demo->elapsed_timer("b"), "all>5*(a+b)");
