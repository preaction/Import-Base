
use strict;
use warnings;
use lib 't/lib';
use Test::More;

eval 'use Moo; 1' or plan skip_all => 'Test requires Moo';

subtest 'apply roles via subref' => sub {
    my $warn;
    local $SIG{__WARN__} = sub { $warn = $_[0] };
    eval q{
        package usecase::applyrole;
        use UseCase::Moo::ApplyRole 'Plugin';
    };
    delete $SIG{__WARN__};

    ok !$@, 'lived' or diag $@;
    ok !$warn, 'no warnings' or diag $warn;
    ok usecase::applyrole->DOES( 'UseCase::Moo::ApplyRole::Role' ), 'role was applied';
};

done_testing;

