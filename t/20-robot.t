#!/usr/bin/perl
use warnings;
use strict;

use Karel::Robot;
use Karel::Grid;
use Test::More;

my $k = 'Karel::Robot'->new;
ok($k, 'constructor');
is(ref $k, 'Karel::Robot');
isnt(eval { $k->left; 1 }, 1, 'no direction');
isnt(eval { $k->grid; 1 }, 1, 'no grid');

my $m = 'Karel::Grid'->new(x => 1, y => 2);
$k->set_grid($m, 1, 1);
is($k->grid, $m, 'grid');
ok($k->does('Karel::Robot::WithGrid'), 'role');
is($k->direction, 'N', 'default direction');

$k->left;
is($k->direction, 'W', 'turn left');
$k->left for 1 .. 3;
is($k->direction, 'N', 'back north');

isnt(eval { $k->run_step; 1 }, 1, 'no step in edit mode');

is($k->facing, 'W', 'facing wall');
$k->left;
my @f = $k->facing_coords;
is($f[0], 0, 'facing x coord');
is($f[1], 1, 'facing y coord');
$k->left;
is($k->facing, ' ', 'facing blank');

done_testing();

