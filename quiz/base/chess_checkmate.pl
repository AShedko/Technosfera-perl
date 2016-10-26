#!/usr/bin/env perl
use strict;
use warnings;

my $filename = 'chess_inp';
my @field;
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
    while (my $row = <$fh>) {
        chomp $row;
        my @temp = split //,$row;
        push(@field,\@temp);

    }
} else {
    die "Could not open file '$filename' $!";
}
for (my $i=0;$i<8;$i++){
    for (my $j=0;$j<8;$j++){
        given($field[$i]->[$j]){
            when('k'){
                knight_moves($i,$j,$field)y;
            }
            when('K'){
                king_moves($i,$j,$field);
            }
            when('B'){bishop_moves($i,$j,@field)}
            when('P'){pawn_moves($i,$j,@field)}
            when('R'){rook_moves($i,$j,@field)}
            when('Q'){queen_moves($i,$j,@filed)}
            when('!'){check_king($i,$j,@field)}
            default{}
        }
    }
}
