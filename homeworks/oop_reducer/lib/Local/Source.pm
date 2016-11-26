package Local::Source;

use 5.022;
use strict;
use warnings;
use Mouse;
use DDP;
=encoding utf8

=head1 NAME

Local::Sourcce - base abstract Source

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub next{}

sub BUILD {
    (my $self) = @_;
    return;
}


1;
