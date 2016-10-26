#!/usr/bin/env perl
use strict;
use warnings;
use 5.20.0;
BEGIN{
    if ($] < 5.018) {
        package experimental;
        use warnings::register;
    }
}

use Getopt::Long;
use Pod::Usage;
use FindBin qw($RealBin);
use lib "$RealBin/../lib";
use Local::MusicLibrary;

my $param = {};
GetOptions($param, 'band=s', 'year=i','track=s','format=s',
           'album=s', 'sort=s','columns|cols=s')
  or pod2usage(1);
my @lines =();
while (<>){
    push(@lines,$_);
}

exit(0) unless (@lines);

# unless (%{$param}) {pod2usage(2)};
create_table(\@lines,$param);
#use DDP;
#p %{$param}
#print("_$param->{band}");

__END__
=head1 NAME

sample - Using GetOpt::Long and Pod::Usage

=head1 SYNOPSIS

sample [options] [file ...]

Options:

    -band BAND` | Оставить только композиции группы `BAND`

    -year YEAR` | Оставить только композиции с альбомов года `YEAR`

    -album ALBUM` | Оставить только композиции с альбомов с именем `ALBUM`

    -track TRACK` | Оставить только композиции с именем `TRACK`

    -format FORMAT` | Оставить только композиции в формате `FORMAT`

    -sort FIELD` | Сортировать по возрастанию значения указанного параметра. `FIELD` может принимать значения `band`, `year`, `album`, `track` и `format`

    -columns COL_1,...,COL_N` | Список колонок через запятую, которые должны появиться в таблице (с учетом порядка). `COL_I` может принимать значения `band`, `year`, `album`, `track` и `format`. Дублирование допускается. Опциональный параметр, при отсутствии — использовать значение по умолчанию.

=head1 OPTIONS

=over 4

LOL hey !!!

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<This program> will read the given input file(s) and do something
useful with the contents thereof.

=cut
