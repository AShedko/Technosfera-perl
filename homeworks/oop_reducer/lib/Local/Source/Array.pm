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
has current_index =>( is=> 'ro', default => 0);
our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub next{
  my $self = shift;
  my $ind = \$self->current_index;
  if ($$ind>= scalar (@{$self->array})) {return;}
  # p $self->array;
  $self->array->[$$ind++];
}

1;
