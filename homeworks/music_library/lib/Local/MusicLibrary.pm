package Local::MusicLibrary;

use strict;
use warnings;
use v5.020;

use DDP;

use Local::MusicLibrary::ParameterProcesser qw|process_params|;
use Local::MusicLibrary::Printer qw|printer|;

use Exporter 'import';

our @EXPORT_OK = qw/create_table/;
our $VERSION = '1.10';

=encoding utf8

=head1 NAME

Local::MusicLibrary - core music library module

=head1 VERSION

Version 1.00

=cut

=head1 SYNOPSIS

=cut

sub create_table($$) {
    (my $lines, my $params ) = @_;
    $lines  ||= [];
    $params ||= {};
    my @table;
    for ( @{$lines} ) {
        chomp;
        $_ =~ m|
        ^
            \. /
            (?<band>[^/]+)
            /
            (?<year>\d+)
            \s+ - \s+
            (?<album>[^/]+)
            /
            (?<track>.+)
            \.
            (?<format>[^\.]+)
            $
        |x;
        push(
            @table,
            {
                band   => $+{band},
                track  => $+{track},
                album  => $+{album},
                format => $+{format},
                year   => $+{year}
            }
        );
    }
    p (@EXPORT_OK);
    (my $goalList, my @result) = process_params(\@table,$params);
    printer( \@result, $goalList);
}

1;
