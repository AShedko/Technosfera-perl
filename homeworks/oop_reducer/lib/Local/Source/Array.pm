package Local::Source::Array;

use 5.022;
use strict;
use warnings;
use Mouse;
use DDP;
=encoding utf8

=head1 NAME

Local::Sourcce::Array - an array representing records

=head1 VERSION

Version 1.00

=cut

has array => (is => 'ro');
my $current_index = 0;
our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub next{
  my $self = shift;
  if ($current_index>= scalar (@{$self->array})) {return;}
  # p $self->array;
  $self->array->[$current_index++];
}

sub BUILD {
    (my $self) = @_;
    return;
}


1;
