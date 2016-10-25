package Local::ParameterProcesser;

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

=encoding utf8

=head1 NAME

Local::ParameterProcesser

Formats input array of hashes with repect to commandd line params

=cut

=head1 SYNOPSIS

=cut

sub process_params($$){
    my $table = [];
    my $params = {};
    ($table, $params) = @_;
    for my $opt (keys %$params){
        given ($opt) {
            when (['band','album','track','format','year']){
                grep {$_{$opt}==$params->{$opt}} @$table;
            }
            when('sort'){
                my $k = $params->{$opt};
                if ($k eq 'year'){
                    sort {0+$a->{$k}<=>0+$b->{$k}} @$table;
                }
                else{sort {$a->{$k}<=>$b->{$k}} @$table;}
            }
        }
    }
}

1;
