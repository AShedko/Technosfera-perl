#! /usr/bin/perl

use ExtUtils::testlib;

use xsSstat;
use DDP;
sub f(){("avg",'cnt','sum')}
# sub f(){(3,2,1)}


my @a = f();

p @a;

# xsSstat::next(sub {print "hi!\n"});
xsSstat::next(\&f);

xsSstat::add("m1",1);
add("m1",4);
add('m2',100);

my $h = xsSstat::stat();

p $h;

$h = stat();

p $h;
