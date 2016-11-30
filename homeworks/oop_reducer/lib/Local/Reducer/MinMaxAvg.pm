package Local::Reducer::MinMaxAvg;

use 5.022;
use strict;
use warnings;
use Local::Source;
use Local::Row;
use DDP;
use Mouse;
use Local::Reducer::MinMaxAvgObj;

extends 'Local::Reducer';

has field => (is => 'ro');
has reduced => (is =>'rw',
          isa => "Local::Reducer::MinMaxAvgObj",
          # default => 1);
          default => sub{return bless {avg => undef, min => undef, max => undef},
           "Local::Reducer::MinMaxAvgObj"});

our $VERSION = '1.00';

=encoding utf8

=head1 NAME

* `Local::Reducer::MinMaxAvg` — считает минимум, максимум и среднее по полю,
указанному в параметре `field`. Результат (`reduced`) отдается в виде
объекта с методами `get_max`, `get_min`, `get_avg`.

=head1 VERSION

Version 1.00

=cut

=head1 SYNOPSIS
`Local::Reducer::MinMaxAvg` — считает минимум, максимум и среднее
=cut

sub max {
  $_[0]>=$_[1] ? $_[0] : $_[1] ;
}

sub min {
  $_[0]>=$_[1] ? $_[1] : $_[0] ;
}

sub step {
  my ($self,$item) = @_;
  my $elem = $item->get($self->field,0);
  my $obj = $self->reduced;
  unless (defined $obj->{sum}) {
      $obj->{sum} = $elem;
      $obj->{min} = $elem;
      $obj->{max} = $elem;
      $obj->{avg} = $elem;
      $obj->{count} = 1;
  }
  else{
    $obj->{count} +=1;
    $obj->{sum} += $elem;
    $obj->{min} = min $obj->{min} , $elem;
    $obj->{max} = max $obj->{max} , $elem;
    $obj->{avg} = $obj->{sum} / $obj->{count};
  }
  return $self->reduced;
}

# sub BUILD {
#   my ($self) = @_;
# }

1;
