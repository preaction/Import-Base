package MyExport;

use base 'Import::Base';

our @EXPORT_OK = qw(joy happiness);

our @IMPORT_MODULES = (
    'strict',
    'warnings',
    feature => [qw( :5.10 )],
    MyExport => [qw( joy )],
);
our %IMPORT_BUNDLES = (
    subs => [
        MyExport => [qw( happiness )],
    ],
    external => [
        'MyStatic' => [qw( Spec )],
    ],
    bundles => [
        MyExport => [qw( external )],
    ],
);

sub joy {
    return "wee";
}

sub happiness {
    return "woo";
}

1;
