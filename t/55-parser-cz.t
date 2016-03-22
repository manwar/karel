#!/usr/bin/perl
use warnings;
use strict;

use Test::More;
use Karel::Parser::Czech;
use utf8;

ok(1, 'used');
my $p = 'Karel::Parser::Czech'->new;
ok($p, 'constructor');

my @valid = qw( dokud kdyz opakuj vlevo krok poloz zvedni stuj
                alpha octothorpe space );

my $fail = eval {
    my ($wrong) = $p->parse(<< '__EOF__');
příkaz chyba
dokud je zeď
  krok
__EOF__
    1 };
my $E = $@;
ok(! $fail, 'failure');
is(ref $E, 'Karel::Parser::Czech::Exception', 'exception object');
is($E->{last_completed}, 'krok', 'last completed');
my @expected = @{ $E->{expected} };
is(scalar @expected, 1 + @valid, 'twelve expected');
for my $lexeme (@valid, 'hotovo') {
    ok(scalar(grep $_ eq $lexeme, @expected), $lexeme);
}

$fail = eval {
    my ($wrong) = $p->parse(<< '__EOF__');
příkaz chyba
dokud je zeď
  krok
hotovo
__EOF__
    1 };
$E = $@;
ok(! $fail, 'failure');
is(ref $E, 'Karel::Parser::Czech::Exception', 'exception object');
like($E->{last_completed}, qr/dokud .* hotovo/xs, 'last completed');
@expected = @{ $E->{expected} };
is(scalar @expected, 1 + @valid, 'twelve expected');
for my $lexeme (@valid, 'konec') {
    ok(scalar(grep $_ eq $lexeme, @expected), $lexeme);
}


my $command_x = << '__EOF__';
příkaz chyba dokud je zeďx
krok hotovo konec
__EOF__

$fail = eval {
    my ($wrong) = $p->parse($command_x);
    1 };
$E = $@;
# TODO: wrap in the exception obj
is(ref $E, q(), 'no obj');
my $pos_x = 1 + index $command_x, 'x';
like($E, qr/ line 1, column $pos_x,/, 'error position');


done_testing();
