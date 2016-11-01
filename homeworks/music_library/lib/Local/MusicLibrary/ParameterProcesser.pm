package Local::MusicLibrary::ParameterProcesser;

use strict;
use warnings;
use v5.020;

no warnings 'experimental';
use Exporter 'import';
our @EXPORT_OK = qw/process_params/;

=encoding utf8

=head1 NAME

Local::ParameterProcesser

Formats input array of hashes with repect to commandd line params

=cut

=head1 SYNOPSIS

=cut

sub process_params($$){
    (my $table, my $params) = @_;
    $table ||= [];
    $params ||= {};
    my @goalList=();
    my $hasGoals ='';
    for my $opt (keys %$params){
        given ($opt) {
            when (['band','album','track','format']){
                @$table = grep {$_->{$opt} eq $params->{$opt}} @$table;
            }
            when ('year'){ #ugly, but more efficient, probably
                @$table = grep {$_->{$opt} == $params->{$opt}} @$table;
            }
            when('sort'){
                my $k = $params->{$opt};
                if ($k eq 'year'){
                    @$table = sort {$a->{$k}<=>$b->{$k}} @$table;
                }
                else{@$table = sort {$a->{$k} cmp $b->{$k}} @$table;}
            }
            when('columns'){
                @goalList = split m/\,/, $params->{$opt};
                $hasGoals=1;
            }
        }
    }
    unless ($hasGoals) { @goalList = qw( band year album track format); }
    return (\@goalList, @$table );
}

1;
