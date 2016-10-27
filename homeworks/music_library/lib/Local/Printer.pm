package Local::Printer;

use strict;
use warnings;
use v5.018;

BEGIN{
    if ($] < 5.018) {
        package experimental;
        use warnings::register;
    }
}

no warnings 'experimental';
use Exporter 'import';

our @EXPORT  = qw/printer/;

=encoding utf8

=head1 NAME

Local::Printer

Prints a table in a specific format

=cut

=head1 SYNOPSIS

=cut

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
#    p $table;
    for my $row (@$table){
        while (my ($key, $val) = each %$row) {
            if ($sizes{$key} < length $val){
                $sizes{$key} = length $val;
            }
        }
    }
    %sizes;
}

use List::Util qw(reduce);

sub printer( $$ ) {
    (my $table, my $goalList) = @_;
    unless (@$goalList and @$table) {return;}
#    p $table;
    my %sizes = get_sizes($table);
#    p %sizes;
    #    my $len = (reduce {$a+$b} values %sizes )+ 3*scalar(@$goalList) -1;
    my $len = (reduce {$a+$b} map {$sizes{$_}} @$goalList) +
        3*scalar(@$goalList) - 1;
    my $hline = ( "-" x ($len));
    print "/$hline\\\n";
    for my $row (@$table) {
        for my $item (@$goalList){
            printf "| %*s ",$sizes{$item},$row->{$item};
        }
        unless ($row == $$table[-1]){
            print "|\n|";
            for my $i (0..scalar(@$goalList)-1){
                print '-'x($sizes{$goalList->[$i]}+2);
                unless ($i == scalar(@$goalList)-1) {print '+';}

            }
            print "|\n";

        }
        else{
          print "|\n\\$hline/\n";
        }
    }
}

1;
