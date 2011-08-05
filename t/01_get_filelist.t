use strict;
use warnings;
use utf8;
use Test::More;
use CPANDiff::API;

my @expected = sort { $a cmp $b } map { trail($_) } (
    'Makefile.PL',                       't/',
    't/00_compile.t',                    't/02_keep_original.t',
    't/01_basic.t',                      'inc/',
    'inc/Module/',                       'inc/Module/Install.pm',
    'inc/Module/Install/',               'inc/Module/Install/WriteAll.pm',
    'inc/Module/Install/Base.pm',        'inc/Module/Install/Fetch.pm',
    'inc/Module/Install/Repository.pm',  'inc/Module/Install/Win32.pm',
    'inc/Module/Install/AuthorTests.pm', 'inc/Module/Install/Makefile.pm',
    'inc/Module/Install/Metadata.pm',    'inc/Module/Install/Can.pm',
    'inc/Module/Install/Include.pm',     'inc/Test/',
    'inc/Test/More.pm',                  'Changes',
    'lib/',                              'lib/Acme/',
    'README',                            '.gitignore',
    'xt/',                               'xt/01_podspell.t',
    'xt/perlcriticrc',                   'xt/02_perlcritic.t',
    'xt/03_pod.t',                       'MANIFEST',
    'lib/Acme/W.pm'
);

my @got =
  sort { $a cmp $b } map { trail($_) } CPANDiff::API->instance->get_file_list(
    release => "Acme-W-0.03",
    author  => "DAMEO"
  );

is_deeply \@got, \@expected;

done_testing;

sub trail {
    local $_ = shift;
    s!/$!!;
    $_;
}
