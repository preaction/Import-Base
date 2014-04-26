package
    MyImporter;

use strict;
use warnings;
use base 'Import::Base';

sub modules {
    strict => [],
    warnings => [],
    'Import::Into' => [],
    feature => [qw( :5.10 )],
}

1;
