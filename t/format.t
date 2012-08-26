#! perl

use v5.16;

use BPO::Format qw<format_timezone>;
use Test::More v0.88;

my @tz_cases = (
    [-10.5, '-10:30'],
    [-10,   '-10:00'],
    [-5.75, '-05:45'],
    [-3,    '-03:00'],
    [-0.5,  '-00:30'],
    [ 0,    '+00:00'],
    [ 0.5,  '+00:30'],
    [ 3,    '+03:00'],
    [ 5.75, '+05:45'],
    [ 10,   '+10:00'],
    [ 10.5, '+10:30'],
);

for (@tz_cases) {
    my ($offset, $expected) = @$_;
    is(format_timezone($offset), $expected,
       "Correct formatted timezone for offset $offset");
}

done_testing();
