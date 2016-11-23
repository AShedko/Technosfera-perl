package Local::Reducer;

use 5.022;
use strict;
use warnings;
use Mouse;

use Local::Source;
use Local::Row;
use DDP;

has 'version', is 'rw';
has 'source', is 'rw', isa 'Source';
has 'initial_value', is 'rw';
has 'row_class', isa 'Row' is  'rw';
our $VERSION = '1.00';

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

=head1 SYNOPSIS

=cut

sub BUILD {
    (my $self,my $src, my $rowcl, my $initial) = @_;
    $self->source = $src;
    $self->initial_value = $initial;
    $self->row_class = $rowcl;
    p $self;
    return;
}

1;
