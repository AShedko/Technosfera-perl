package Local::Row::Simple;

use 5.022;
use strict;
use warnings;
use Mouse;
use DDP;

extends Local::Row;

=encoding utf8

=head1 NAME

Local::Row::Simple — каждая строка — набор пар `ключ:значение`,
соединенных запятой. В ключах и значениях не может быть двоеточий и запятых.


=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

Local::Row::Simple — каждая строка — набор пар `ключ:значение`

=cut

sub get {
  my ($self, $name, $default) = @_;
  my $str = $self->str;
  my %h;      # Так менее понятно, но безопаснее  
  $h{$1} = $2 while $str =~ m/([^:]*):\s*([^,]*),?/g;
  return $h{$name} if $h{$name};
  return $default;
}

1;
