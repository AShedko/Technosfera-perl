package Local::Reducer;

use 5.022;
use strict;
use warnings;
use Local::Source;
use DDP;
use Mouse;

has version => (is => 'rw');
has source =>  (is =>'rw');
has initial_value =>( is => 'rw');
has row_class => ( is => 'rw');
has reduced => (is => 'rw');
our $VERSION = '1.00';

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

=head1 SYNOPSIS

=cut

sub reduce_n {
  my ($self,$n) = @_;
  my $item;
  my $str;
  for (0..$n-1) {
    $str = $self->source->next();
    if ($str){
      $item = $self->row_class->new({str => $str});
      $self->step($item);
    }
  }
  $self->{reduced};
}

sub reduce_all {
  my ($self) = @_;
  my $res = 1;
  my $item;
  while (1){
    $res = $self->source->next();
    unless ($res) {
      return $self->{reduced};
    }
    $item = $self->row_class->new({str => $res});
    $self->step($item);
  }
}

sub step {}

# sub reduced {
#   my ($self) = @_;
#   $self->reduced;
# }

sub BUILD {
    my ( $self ) = @_;
    # p $self;
    $self->{reduced} = ($self->initial_value);
    my $inc = $self->row_class;
    $inc =~ s/::/\//g;
    require $inc.'.pm';
    return;
}

1;
