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
my @elems;
my $current_index = 0;
our $VERSION = '1.00';

=head1 SYNOPSIS

Local::Sourcce::Text - A string, separated by newlines (UNIX-style \n)
or specified by delimiter

=cut

sub next{
  my $self = shift;
  if ($current_index>= scalar (@elems)) {return;}
  $elems[$current_index++];
}

sub BUILD {
    (my $self) = @_;
    @elems = split $self->delimiter,$self->text;
    return;
}


1;
