#! /usr/bin/perl

use ExtUtils::testlib;

use xsSstat;
use DDP;
sub f(){("avg")}
# sub f(){(3,2,1)}


my @a = f();

p @a;

# xsSstat::next(sub {print "hi!\n"});
xsSstat::next(\&f);

xsSstat::add("m1",1);
add("m1",4);

my $h = xsSstat::stat();

p $h;
