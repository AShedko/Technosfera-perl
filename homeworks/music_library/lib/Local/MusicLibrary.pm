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
    (my @result, my @goalList) = process_params(\@table,$params);
    printer( \@result, \@goalList);
}

sub get_sizes( $ ) {
    my $table = [];
    ($table) = @_;
    my %sizes = (
        band   => 1,
        track  => 1,
        album  => 1,
        format => 1,
        year   => 1
    );
    for my $row (@$table) {
        for my $k ( keys %$row ) {
            my $v = $row->{$k};
            if ( length $sizes{$k} < length $v ) {
              $sizes{$k} = $v
            };
        }
    }
    %sizes;
}

use List::Util qw(reduce);

sub printer( $$ ) {
    (my $table, my $goalList) = @_;
    my %sizes = get_sizes($table);
    my $hline = ( "-" x (reduce {$a+$b} values %sizes));
    print "/$hline\\\n";
    for my $row (@$table) {
        print "|";

        unless ($row == $$table[-1]){
          print "\n|" . ( "-" x 80 ) . "|\n";
        }
        else{
          print "\n\\$hline/\n";
        }
    }
}

1;
