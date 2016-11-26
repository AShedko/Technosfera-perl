package Local::Reducer::MaxOverallDiff;

use 5.022;
use strict;
use warnings;
use Local::Source;
use Local::Row;
use DDP;
use Mouse;

extends 'Local::Reducer';

has version => (is => 'rw');
has source =>  (is =>'rw');
has initial_value =>( is => 'rw');
has row_class => ( is => 'rw');
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
my ($maxtop,$maxbot,$mintop,$minbot);

sub max {
  $_[0]>=$_[1] ? $_[0] : $_[1] ;
}

sub min {
  $_[0]>=$_[1] ? $_[1] : $_[0] ;
}


sub step {
  my ($self,$item) = @_;
  my $el_top = $item->get($self->top,$self->initial_value);
  unless (defined $maxtop){
    ($maxtop,$mintop) = ($el_top,$el_top);
  }
  my $el_bot = $item->get($self->bottom,$self->initial_value);
  unless (defined $maxbot){
    ($maxbot,$minbot) = ($el_bot,$el_bot);
  }

  $maxbot = max($maxbot,$el_bot);
  $minbot = min($minbot,$el_bot);
  $maxtop = max($maxtop,$el_top);
  $mintop = min($mintop,$el_top);
  my $maxdist = max( abs $maxtop-$minbot, abs $maxbot - $mintop);
  $self->{reduced} = $maxdist;
}

1;
