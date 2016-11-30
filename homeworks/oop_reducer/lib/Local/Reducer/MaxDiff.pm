package Local::Reducer::MaxDiff;

use 5.022;
use strict;
use warnings;
use Local::Source;
use Local::Row;
use DDP;
use Mouse;

extends 'Local::Reducer';

has top => (is => 'rw');
has bottom => (is => 'rw');

our $VERSION = '1.00';

=encoding utf8

=head1 NAME

Local::Reducer::MaxOverallDiff
выясняет максимальную разницу между полями, указанными в
параметрах `top` и `bottom` конструктора, среди всех строк лога.
=head1 VERSION

Version 1.00

=cut

=head1 SYNOPSIS
Local::Reducer::MaxDiff— maximal difference between top and bottom fields
=cut
sub max {
  $_[0]>=$_[1] ? $_[0] : $_[1] ;
}

sub step {
  my ($self,$item) = @_;
  my $el_top = $item->get($self->top,$self->initial_value);
  my $el_bot = $item->get($self->bottom,$self->initial_value);
  my $maxdist = abs $el_top - $el_bot;
  $self->{reduced} = max $maxdist, $self->{reduced};
}

1;
