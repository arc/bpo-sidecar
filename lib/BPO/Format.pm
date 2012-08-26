package BPO::Format;

use v5.16;
use warnings;

use Exporter qw<import>;
our @EXPORT_OK = qw<format_timezone>;

sub format_timezone {
    my ($offset) = @_;

    my $hours = int $offset;
    my $minutes = 60 * abs($offset - $hours);
    my $zone = sprintf '%+03d:%02d', $hours, $minutes;
    $zone =~ s/\A \+/-/xms
        if $offset < 0 && $hours >= 0;
    return $zone;
}

1;
