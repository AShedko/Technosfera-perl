=head1 DESCRIPTION

Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение

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

sub evaluate {
	my $rpn = shift;
  my @stack;
  for my $c (@{$rpn}){
      given ($c) {
          when (['+','-','*','/','^']){#Binary operators
              my $x = pop(@stack);
              my $y = pop(@stack);
              given ($c){
                  when ("*") { push( @stack, $x * $y ) }
                  when ("+") { push( @stack, $x + $y ) }
                  when ("/") { push( @stack, $y / $x ) }
                  when ("-") { push( @stack, $y - $x ) }
                  when ("^") { push( @stack, $y ** $x )}
              }
          }
          when (['U+','U-']){#Unary operators
              if($c eq 'U-'){  my $x = pop(@stack);push(@stack, -$x)}
          }
          default{
              push(@stack, $c);
          }
      }
  }
	return pop(@stack);
}

1;
