=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";

sub priority($){
    my $op=shift;
    given ($op){
        when (['U+','U-']) {return 4;}
        when (['^']){return 3;}
        when (['*','/']){return 2;}
        when (['+','-']){return 1;}
        default{return 0;}
    }
}

sub rpn {
	my $expr = shift;
	my $source = tokenize($expr);
	my @rpn;

#  my @stack;
  my @op;

  for my $c (@{$source}){
      given ($c){
          when (['+','-','*','/','U+','U-','^']){#operation
              if ($c=~/U[\+\-]|\^/){#right assoc
                  while (priority($c)<priority($op[-1])){
                      push(@rpn,pop(@op));
                  }
              }
              else{
                  while (priority($c)<=priority($op[-1])){
                      push(@rpn,pop(@op));
                  }
              }
              push(@op,$c);
          }
          when('('){#bra
              push(@op,$c);
          }
          when(')'){#ket
              while($op[-1] ne '('){
                  if (@op){push(@rpn,pop(@op));}
                  else {die "Incorrect brackets ";}
              }
              pop(@op);
          }
          default{#numeric
              $c = 0+$c;
              push(@rpn,"$c");
          }
      }
  }
  while (@op and $op[-1] ne '('){
      push(@rpn,pop(@op));
  }
  if (@op) {die "Bad @{$source}";}
	return \@rpn;
}

unless (caller){
    use Data::Dumper;
    while (my $expression = <>) {
        next if $expression =~ /^\s*$/;
        print Dumper(rpn($expression));
    }
}


1;
