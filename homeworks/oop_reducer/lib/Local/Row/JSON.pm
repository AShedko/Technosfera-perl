package Local::Row::JSON;

use 5.022;
use strict;
use warnings;
use Mouse;
use DDP;
use JSON::XS;

extends Local::Row;

=encoding utf8

=head1 NAME

Local::Row::JSON — каждая строка — JSON объект

=head1 VERSION

Version 1.00

=cut

our $JSON = JSON::XS->new->utf8;

our $VERSION = '1.00';

=head1 SYNOPSIS

Local::Row::JSON — каждая строка — JSON объект

=cut

sub get {
  my ($self, $name, $default) = @_;
  my $h = $JSON->decode($self->str);
  # p $h;
  return $h->{$name} if $h->{$name};
  return $default;
}

1;
