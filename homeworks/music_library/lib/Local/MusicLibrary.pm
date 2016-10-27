package Local::MusicLibrary;

use strict;
use warnings;

BEGIN {
    if ( $] < 5.018 ) {

        package experimental;
        use warnings::register;
    }
}
use Exporter 'import';

use Local::ParameterProcesser;
use Local::Printer;

our @EXPORT  = qw/create_table/;
our $VERSION = '1.00';

=encoding utf8

=head1 NAME

Local::MusicLibrary - core music library module

=head1 VERSION

Version 1.00

=cut

=head1 SYNOPSIS

=cut

use DDP;

sub create_table($$) {
    my $lines  = [];
    my $params = {};
    ( $lines, $params ) = @_;
    my @table;
    for ( @{$lines} ) {
        chomp;
        $_ =~ m{
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
        }x;
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
    (my $goalList, my @result) = process_params(\@table,$params);
    printer( \@result, $goalList);
}

1;
