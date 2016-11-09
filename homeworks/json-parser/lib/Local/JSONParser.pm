package Local::JSONParser;

use strict;
use warnings;
use 5.022;
use base qw(Exporter);
use utf8;
our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );
use DDP;
use Encode qw/encode decode/;
#use re 'debug';


sub _fail { die __PACKAGE__.": $_[0] at offset ".pos()."\n" }

# The {..} block in regex returns it`s value into $^R
# So $^R can be used to parse the JSON as it is being
# matched.
# During execution, $^R is a nested list

our $FROM_JSON = qr{
(?:
    ^(?: (?&NUMBER)|(?&STRING)|true|false|null)$ (?{_fail "no non-refs!"})
|

    (?&VALUE) (?{$_ = $^R->[1] })
#    (?&ARRAY) (?{$_ = $^R->[1] })
#|
#    (?&OBJECT) (?{$_ = $^R->[1] })
|
    \z (?{ _fail "Unexpected end of input" })
|
      (?{ _fail "Invalid literal" })
)
(?(DEFINE)
(?<OBJECT>
  \{\s*
    (?{ [$^R, {}] })
    (?:
        (?&KV) # [[$^R, {}], $k, $v]
        (?{ [$^R->[0][0], {$^R->[1] => $^R->[2]}] })
        \s*
        (?:
            (?:
                ,\s* (?&KV) # [[$^R, {...}], $k, $v]
                (?{ $^R->[0][1]{ $^R->[1] } = $^R->[2]; $^R->[0] })
            )*
        |
            (?:[^,\}]|\z) (?{ _fail "Expected ',' or '\x7d'" })
        )*
    )?
    \s*
    (?:
        \}
    |
        (?:.|\z) (?{ _fail "Expected closing of hash" })
    )
)
(?<KV>
  \s*
  (?&STRING) # [$^R, "string"]
  \s*
  (?:
      :\s* (?&VALUE) # [[$^R, "string"], $value]
      (?{ [$^R->[0][0], $^R->[0][1], $^R->[1]] })
  |
      (?:[^:]|\z) (?{ _fail "Expected ':'" })
  )
)
(?<ARRAY>
  \[\s*
  (?{ [$^R, []] })
  (?:
      (?&VALUE) # [[$^R, []], $val]
      (?{ [$^R->[0][0], [$^R->[1]]] })
      \s*
      (?:
          (?:
              ,\s* (?&VALUE)
              (?{ push @{$^R->[0][1]}, $^R->[1]; $^R->[0] })
          )*
      |
          (?: [^,\]]|\z ) (?{ _fail "Expected ',' or '\x5d'" })
      )
  )?
  \s*
  (?:
      \]
  |
      (?:.|\z) (?{ _fail "Expected closing of array" })
  )
)
(?<VALUE>
  \s*
  (
      (?&STRING)
  |
      (?&NUMBER)
  |
      (?&OBJECT)
  |
      (?&ARRAY)
  |
      true (?{ [$^R, 1] })
  |
      false (?{ [$^R, 0] })
  |
      null (?{ [$^R, undef] })
  )
    #(?{p $^R;})
  \s*
)
(?<STRING>
  (
    "
    (?:
        [^\\"]+ # non-special symbols
    |
        \\ ["\\/bfnrt] #control symbols
    |
      \\ u [0-9a-fA-f]{4} # unicode codes
    |
        \\ . (?{ _fail "Invalid string escape character" })
    )*
    (?:
        "
    |
        (?:\\|\z) (?{ _fail "Expected closing of string" })
    )
  )
  (?{ [$^R, substr(_decode_str($^N),1,-1)]})
)       # $^N - last assigned capture
(?<NUMBER>
  (
    -?
    (?: 0 | [1-9]\d* )
    (?: \. \d+ )?
    (?: [eE] [-+]? \d+ )?
  )
  (?{ [$^R, 0+$^N] })
)
) }xms;

my %escape_codes = (
    "\\" => "\\",
    "\"" => "\"",
    "b" => "\b",
    "f" => "\f",
    "n" => "\n",
    "r" => "\r",
    "t" => "\t",
);

sub _decode_str {
    my $str = shift;
    #           2-nd capture  3-d capture        4-th capture
    #               ||            ||                 ||
    #               \/            \/                 \/
    $str =~ s[(\\(?:([0-7]{1,3})|x([0-9A-Fa-f]{1,2})|(.)))]
             [defined($2) ? chr(oct $2) :
                  defined($3) ? chr(hex $3) :
                      $escape_codes{$4} ? $escape_codes{$4} :
              $1]eg;

    $str =~ s[\\u([0-9A-Fa-f]{4})][ chr hex $1]eg;
    #say $str;
    #$str =~ s/\\\\x/'\x'/ge;
    #$str =~ s/@/'\@'/ge;
#    for my $c (split //,$str){
     #   print $c."_";
    #}
#    $str = decode('utf8', $str);
    $str;
}


sub parse_json {
  local $_ = shift;
  local $^R; # Result of evaluation in REGEX
  $_ = decode "utf-8", $_;
  eval { m{\A$FROM_JSON\z}; } and return $_;
  die $@ if $@;
  return 'no match';
}

1;
