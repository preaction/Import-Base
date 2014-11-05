package
    MyStaticSubrefs;

use strict;
use warnings;
use base 'MyStatic';

our @IMPORT_MODULES = (
    '-strict' => sub { return [ 'vars' ] },
    sub { return -warnings => [qw( uninitialized )] },
);

our %IMPORT_BUNDLES = (
    'Spec' => [
        'File::Spec::Functions' => [qw( catfile )],
    ],
    Lax => [
        '-strict',
        sub {
            my ( $bundles, $args ) = @_;
            return '-warnings';
        },
    ],
    Inherit => [
        sub {
            my ( $bundles, $args ) = @_;
            no strict 'refs';
            my $class = caller 1;
            push @{ "${class}::ISA" }, 'inherited';
            return;
        },
    ],
);

package
    inherited; # dummy package to inherit from

1;
