package Local::Source::FileHandler;

use 5.022;
use strict;
use warnings;
use Mouse;
use DDP;
=encoding utf8

=head1 NAME

Local::Sourcce::FileHandler - A file, which contains records
separated by newlines (UNIX-style \n) or specified by delimiter

=head1 VERSION

Version 1.00

=cut

has fh => (is => 'ro');
has delimiter => (is => 'ro');
my @elems;
my $current_index = 0;
our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub next{
  my ($self) = @_;
  my $lc_fh = $self->fh;
  my $line = <$lc_fh>;
  unless ($line) {return;}
  chomp $line;
  $line;
}

sub BUILD {
    my ($self) = @_;
    return;
}


1;
