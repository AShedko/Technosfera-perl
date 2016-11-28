package Local::Source::Text;

use 5.022;
use strict;
use warnings;
use Mouse;
use DDP;
=encoding utf8

=head1 NAME

Local::Sourcce::Text - A string, separated by newlines (UNIX-style \n)
or specified by delimiter

=head1 VERSION

Version 1.00

=cut

has text => (is => 'ro');
has delimiter => (is => 'ro', default => '\n');
has elems => (is => 'rw', default => sub {[]});
has current_index => (is => 'rw', default =>0);
our $VERSION = '1.00';

=head1 SYNOPSIS

Local::Sourcce::Text - A string, separated by newlines (UNIX-style \n)
or specified by delimiter

=cut

sub next{
  my $self = shift;
  my $aref = $self->elems;
  my $ind  = \$self->current_index;
  if ($self->current_index >= scalar (@{$self->elems})) {return;}
  $aref->[$$ind++];
}

sub BUILD {
    (my $self) = @_;
    my @ar = split $self->delimiter, $self->text;
    my $aref = $self->elems;
    @$aref = @ar;
    return;
}


1;
