
use strict;
use warnings;
use lib 't/lib';
use Test::Most;
use Test::Import import => [qw( :all )];

does_import_strict 'MyImporter';
does_import_warnings 'MyImporter';
does_import_class 'MyImporter', 'Import::Into';
done_testing;
