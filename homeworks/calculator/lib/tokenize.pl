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
  $|++;     # Enable autoflush on STDOUT
	$, = " "; # Separator for print x,y,z
	$" = " "; # Separator for print "@array";
}
no warnings 'experimental';
use constant EXP=>1;
use constant OP=>2;
use constant UN=>3;


sub tokenize {
	chomp(my $expr = shift);
	my @res;
  my @chunks = split(m{([-+*/()])}, $expr);
  my $prev = "";
  my $state = 0;
  for my $c (@chunks){
      given ($c){
          when (/^\s*$/) {} # то-же самое
          when (/\d*.?\d+E/){ # элемент содержит число в эксп. записи
              $prev.=$c;
              $state = 1;
          }
          when (/\d*.?\d+/) { # элемент содержит число
              if ($state==EXP){
                  $prev.=$c;
                  push(@res,$prev);
                  $prev="";
                  $state=0;
              }
              else{push(@res,$c);}
          }
          when ([ '+','-' ]){ # элемент "+" или "-"
              if ($state==EXP){
                  $prev.=$c;
              }
              elsif($state==OP or $state==UN){push(@res,("U".$c));$state=UN}
              else {push(@res,$c);$state=OP}
          }
          when(['(',')']){
              push(@res,$c);
              $state=0;
          }
          when(['*','/']){
              unless ($state){
                  push(@res,$c);
              }
              else {
                  die "incorrect operators: '$_'";
              }

          }
          default {
              die "Bad: '$_'";
}
      }
  }
	return \@res;
}
if ($__FILE__ eq $__MAIN__){
    use Data::Dumper;
    while (my $expression = <>) {
        next if $expression =~ /^\s*$/;
        print Dumper(tokenize($expression));
    }
}
