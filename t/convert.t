#! perl

use v5.16;

use BPO::Convert qw<convert_entry_text>;
use Path::Class qw<file>;
use Test::Differences;
use Test::More v0.88;

unified_diff;

my $files_processed = 0;
file(__FILE__)->dir->subdir('data/convert')->recurse(callback => sub {
    my ($file) = @_;
    return if !-f $file;

    my $data = $file->slurp(iomode => '<:utf8');
    my ($mode, $todo, $input, $expected) = $data =~ m{ \A
        mode:  \h* (\w+) \h* \n
        (?: from: [^\n]* \n )?
        (?: todo: \h* ([^\n]+) \n )?
        input: \h* \n
        ( (?: (?: \x20\x20 [^\n]*+ )?+ \n)*+ ) \n*
        output: \h* \n
        ( (?: (?: \x20\x20 [^\n]*+ )?+ \n)*+ ) \s* \z
    }axms or die "Test bug: can't parse $file\n";
    s/^  //mg for $input, $expected;

    my $got = convert_entry_text($mode, $input);

    TODO: {
        local $TODO = $todo;
        eq_or_diff($got, $expected, "Got expected output for $file\n");
    }

    $files_processed++;
});

die "Test bug: no inputs found in t/data/convert/\n" if !$files_processed;

done_testing();
