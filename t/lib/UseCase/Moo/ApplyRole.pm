package
    UseCase::Moo::ApplyRole;

use strict;
use warnings;
use Test::More;
use base 'Import::Base';

our @IMPORT_MODULES = (
    'Moo',
);

our %IMPORT_BUNDLES = (
    'Plugin' => [
        sub {
            my ( $bundles, $args ) = @_;
            Moo::Role->apply_role_to_package( $args->{package}, 'UseCase::Moo::ApplyRole::Role' );
            ();
        },
    ],
    'WithRequires' => [
        sub {
            my ( $bundles, $args ) = @_;
            Moo::Role->apply_role_to_package( $args->{package}, 'UseCase::Moo::ApplyRole::WithRequires' );
            ();
        },
    ],
);

package
    UseCase::Moo::ApplyRole::Role;
use Moo::Role;
around BUILDARGS => sub { };

package
    UseCase::Moo::ApplyRole::WithRequires;

use Moo::Role;
requires 'my_attr';

1;
