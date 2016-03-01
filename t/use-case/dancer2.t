
use strict;
use warnings;
use lib 't/lib';
use Test::More;

BEGIN { eval 'require Dancer2; 1' or plan skip_all => 'Test requires Dancer2' };

use Test::More;

BEGIN {
    package MyBase;
    use base 'Import::Base';
    our @IMPORT_MODULES = ( 'Dancer2', 'Dancer2::Plugin::Ajax' );
};

BEGIN { MyBase->import };

can_ok( __PACKAGE__, 'dancer_version' );
can_ok( __PACKAGE__, 'dsl' );
{
    local $TODO = "Test fails because Dancer2::Plugin does not work with Module::Runtime. See https://github.com/PerlDancer/Dancer2/pull/1136";
    can_ok( __PACKAGE__, 'ajax' );
}

done_testing;

