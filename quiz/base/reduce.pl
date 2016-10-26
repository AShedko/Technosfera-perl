#!/usr/bin/env perl
#use Modern::Perl 2013;

sub reduce(&@) {
    my ($f, @list) = @_;
    my $res=shift(@list);
    for (@list){
        $res=&$f($res,$_);
    }
    return $res;
}

sub reduce_ref(&$) {
    my ($f, $listRef) = @_;
    my $res=$listRef->[0];
    for (@{$list}[1..]){
        $res=&$f($res,$_);
    }
    return $res;
}



print reduce {
    my ($sum, $i) = @_;
    $sum + $i;
} 1, 2, 3, 4;
print "\n";
print reduce {
    my ($sum, $i) = @_;
    $sum . $i;
} 1, 2, 3, 4;

