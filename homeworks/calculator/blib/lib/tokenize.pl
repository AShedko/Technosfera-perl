=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, состоящий из отдельных токенов.
Токен - это отдельная логическая часть выражения: число, скобка или арифметическая операция
В случае ошибки в выражении функция должна вызывать die с сообщением об ошибке

Знаки '-' и '+' в первой позиции, или после другой арифметической операции стоит воспринимать
как унарные и можно записывать как U-" и "U+"

Программа должна читать выражения из стандартного ввода.
Стоит заметить, что после унарного оператора нельзя использовать бинарные операторы
Например последовательность 1 + - / 2 невалидна. Бинарный оператор / идёт после использования унарного "-"

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
use constant OP=>2;
use constant UN=>3;
use constant NUM=>4;


sub tokenize {
	chomp(my $expr = shift);
	my @res;
  my @chunks = split m{((?<!e)[-+]|[*()/^]|\s+)},$expr;
  my $prev = "";
  my $state = 0;
  for my $c (@chunks){
      given ($c){
          when (/^\s*$/) {} # то-же самое
          when (/^\d*\.?\d+([eE][+-]?\d+)?$/) { # элемент содержит число))
              push(@res,$c);
              $state=NUM;
          }
          when (['+','-']){ # элемент "+" или "-"
              if($state==NUM){push(@res,$c);$state=OP}
              else {push(@res,("U".$c));$state=UN;}
         }
          when(['(',')']){
              push(@res,$c);
              if ($c eq '('){$state = 0;}
              else {$state = NUM;}
          }
          when(['*','/','^']){
              if($state==NUM){
                  push(@res,$c);
                  $state=OP;
              }
              else {
                  die "incorrect operators: '$_'";
              }

          }#хлебозаводский проезд д 7 стр 10
          default {
              die "Bad: '$_'";
}
      }
  }
  unless ($state==NUM){die "No nums or wrong parentesis! '$expr'"}
	return \@res;
}

unless (caller){
    use Data::Dumper;
    while (my $expression = <>) {
        next if $expression =~ /^\s*$/;
        print Dumper(tokenize($expression));
    }
}

1;
