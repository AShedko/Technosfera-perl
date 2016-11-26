package Local::Row;

use 5.022;
use strict;
use warnings;
use Mouse;
use DDP;

=encoding utf8

=head1 NAME

Local::Row - base abstract Row

=head1 VERSION

Version 1.00

=cut

has str => (is => "ro");

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub get {
  my ($self,$name, $default) = @_;
  my @pairs = split ',', $self->str;
  for (@pairs){
    $_ =~ /(.*):(.*)/;
    if ($1 eq $name) {return $2;};
  }
  return $default;
}

sub BUILD {
    my ($self) = @_;
    return;
}

1;
