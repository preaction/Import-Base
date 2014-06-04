package
    MyImporter;

use strict;
use warnings;
use base 'Import::Base';

sub modules {
    strict => [],
    warnings => [],
    'Module::Runtime' => [qw( use_module is_module_name check_module_name )],
}

1;
