package Local::Reducer::Sum;

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
# has reduced => (is => 'rw');
has field => (is => 'rw');
our $VERSION = '1.00';

=encoding utf8

=head1 NAME

Local::Reducer::Sum — суммирует значение поля,
указанного в параметре `field` конструктора, каждой строки лога.

=head1 VERSION

Version 1.00

=cut

=head1 SYNOPSIS

Local::Ruducer::Sum -- Sums the values in field

=cut

sub step {
  my ($self,$item) = @_;
  my $elem = $item->get($self->field,0);
  $self->{reduced} = $self->{reduced} + 0+ $elem;
}

1;
